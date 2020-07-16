import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/product_state.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _firstRun = true;
  bool _isLoading = false;
  Map _initValues = {
    'name': '',
    'desc': '',
    'price': '',
  };
  Product _editedProduct = new Product(
      id: null, desc: '', name: '', price: 0, imageUrl: '0', isFavorite: false);

  @override
  void dispose() {
    _imageUrlController.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    if (_editedProduct.id != null) {
      await Provider.of<ProductState>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct)
          .catchError(
        (error) {
          return showDialog<Null>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('An error occurred!'),
              content: Text(
                  'Something went wrong, most likely no internet connection'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Go back'),
                ),
              ],
            ),
          );
        },
      );
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ProductState>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError(
        (error) {
          return showDialog<Null>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('An error occurred!'),
              content: Text(
                  'Something went wrong, most likely no internet connection'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Go back'),
                ),
              ],
            ),
          );
        },
      ).then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_firstRun) {
      final String productId =
          ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductState>(context, listen: false)
            .findById(productId);
        _initValues = {
          'name': _editedProduct.name,
          'desc': _editedProduct.desc,
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _firstRun = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editedProduct.id != null
            ? Text("Edit Product")
            : Text("Add Product"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['name'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'Provide a Topic.';
                          return null; //! input is correct
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            desc: _editedProduct.desc,
                            name: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) return 'Provide a Price.';
                          if (double.tryParse(value) == null)
                            return 'Provide a valid number.';
                          double parsed = double.parse(value);
                          if (parsed <= 0)
                            return 'Provide ammount greater than zero!';
                          return null; //! input is correct
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        focusNode: _priceFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            desc: _editedProduct.desc,
                            name: _editedProduct.name,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['desc'],
                        decoration: InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value.isEmpty) return 'Provide a Description.';
                          if (value.length < 10)
                            return 'Provide a longer description atleast 10 characters';
                          return null; //! input is correct
                        },
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            desc: value,
                            name: _editedProduct.name,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Center(child: Text('Enter a URL'))
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  desc: _editedProduct.desc,
                                  name: _editedProduct.name,
                                  price: _editedProduct.price,
                                  imageUrl: value,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Provide a image Url.';
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https'))
                                  return 'Provide a valid Url.';
                                if (value.contains('tinyurl')) return null;
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.png') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('.gif'))
                                  return 'It could be a not valid image';
                                return null; //! input is correct
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
