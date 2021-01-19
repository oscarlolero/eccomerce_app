import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:form_validation/src/models/product_model.dart';
import 'package:form_validation/src/providers/products_provider.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productsProvider = new ProductsProvider();

  ProductModel product = new ProductModel();
  bool _saving = false;

  File photo;

  @override
  Widget build(BuildContext context) {
    //verificar si viene con argumetnos
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () => _processImage(ImageSource.gallery),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _processImage(ImageSource.camera),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _showPhoto(),
                _buildName(),
                _buildPrice(),
                SizedBox(height: 15),
                _buildIsAvailable(),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      //se ejecuta despues de validar el campo
      onSaved: (value) => product.title = value,
      validator: (value) {
        if (value.length < 5) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (val) => product.value = double.parse(val),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      textColor: Colors.white,
      label: Text(product.id != null ? 'Actualizar' : 'Guardar'),
      icon: Icon(Icons.save),
      onPressed: _saving ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    setState(() {
      _saving = true;
    });

    if(photo != null) {
      product.photoUrl = await productsProvider.uploadImage(photo);
    }

    if (product.id == null) {
      productsProvider.createProduct(product);
    } else {
      print(product.id);
      productsProvider.editProduct(product);
    }

    showSnackbar('Registro guardado.');
    Navigator.pop(context);
  }

  Widget _buildIsAvailable() {
    return SwitchListTile(
      title: Text('Disponible'),
      value: product.available,
      activeColor: Colors.deepPurple,
      onChanged: (val) => setState(() {
        product.available = val;
      }),
    );
  }

  void showSnackbar(String message) {
    final snackbar = SnackBar(
        content: Text(message), duration: Duration(milliseconds: 1500));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _showPhoto() {
    if(product.photoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(product.photoUrl),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        //photo tiene valor? y si si lo tiene, toma el path, si es nulo, usa 'assets/no-image.png'
        image: AssetImage(photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  void _processImage(ImageSource imageSource) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: imageSource,
    );

    photo = File(pickedFile.path);

    if (photo != null) {
      product.photoUrl = null;
    }

    setState(() {});
  }
}
