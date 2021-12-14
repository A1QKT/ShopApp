import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/product.dart';

class EditScreen extends StatefulWidget {
  static String routeName = "/edit-screen.json";

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final key = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  bool _hasImage = false;
  Product _edittedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  @override
  void dispose() {
    _imageUrlController.dispose();
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  bool _isLoadingSubmit = false;
  void _submit() {
    if (key.currentState.validate()) {
      key.currentState.save();
    }
  }

  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final id = ModalRoute.of(context).settings.arguments;
      if (id != null) {
        _edittedProduct = Provider.of<Products>(context, listen: false)
            .getProduct
            .firstWhere((element) => (element.id == id));
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edditing mode"),
          centerTitle: true,
        ),
        body: Container(
          child: Form(
              key: key,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: "title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        if (key.currentState.validate())
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) return "Please input the title";
                        return null;
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                            id: _edittedProduct.id,
                            title: value,
                            price: _edittedProduct.price,
                            description: _edittedProduct.description,
                            imageUrl: _edittedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "price"),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) return "Please input the price";
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (key.currentState.validate())
                          FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                            id: _edittedProduct.id,
                            title: _edittedProduct.title,
                            price: double.parse(value),
                            description: _edittedProduct.description,
                            imageUrl: _edittedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      focusNode: _descriptionNode,
                      decoration: InputDecoration(labelText: "description"),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty)
                          return "Please input the description";
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (key.currentState.validate())
                          FocusScope.of(context)
                              .requestFocus(_imageUrlFocusNode);
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                            id: _edittedProduct.id,
                            title: _edittedProduct.title,
                            price: _edittedProduct.price,
                            description: value,
                            imageUrl: _edittedProduct.imageUrl);
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(border: Border.all(width: 1)),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: _hasImage
                                  ? Image.network(_imageUrlController.text)
                                  : Text("Not Entered Image"),
                            )),
                        Expanded(
                          child: TextFormField(
                            focusNode: _imageUrlFocusNode,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(labelText: "url image"),
                            controller: _imageUrlController,
                            textInputAction: TextInputAction.done,
                            validator: (val) {
                              if (val.startsWith("http") ||
                                  val.startsWith("https") ||
                                  val.endsWith(".png") ||
                                  val.endsWith(".jpg") ||
                                  val.endsWith("jpeg")) {
                                return null;
                              }
                              return "Please input in the right URL";
                            },
                            onFieldSubmitted: (_) {
                              _submit();
                            },
                            onChanged: (val) {
                              if (val != null &&
                                  (val.startsWith("http") ||
                                      val.startsWith("https")) &&
                                  (val.endsWith(".png") ||
                                      val.endsWith(".jpg") ||
                                      val.endsWith("jpeg"))) {
                                setState(() {
                                  _hasImage = true;
                                });
                              } else
                                setState(() {
                                  _hasImage = false;
                                });
                            },
                            onSaved: (value) async {
                              _edittedProduct = Product(
                                id: _edittedProduct.id,
                                title: _edittedProduct.title,
                                price: _edittedProduct.price,
                                description: _edittedProduct.description,
                                imageUrl: value,
                              );
                              try {
                                setState(() {
                                  _isLoadingSubmit = true;
                                });
                                await Provider.of<Products>(context,
                                        listen: false)
                                    .updateProduct(
                                        _edittedProduct.id, _edittedProduct);
                                setState(() {
                                  _isLoadingSubmit = false;
                                });
                                Navigator.of(context).pop();
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: const Text(
                                            "Can't add your product! Check your connection")));
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_isLoadingSubmit) CircularProgressIndicator(),
                  ],
                ),
              )),
        ));
  }
}
