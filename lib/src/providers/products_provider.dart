import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:form_validation/src/models/product_model.dart';

class ProductsProvider {
  final String _url =
      'https://flutter-course-5b319-default-rtdb.firebaseio.com';

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/products.json';
    final response = await http.post(url, body: productModelToJson(product));

    final decodedData = json.decode(response.body);
    print(decodedData);
    return true;
  }

  Future<bool> editProduct(ProductModel product) async {
    final url = '$_url/products/${product.id}.json';
    final response = await http.put(url, body: productModelToJson(product));

    final decodedData = json.decode(response.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductModel>> loadProducts() async {
    final url = '$_url/products.json';
    final response = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<ProductModel> products = new List();

    if (decodedData == null) return [];

    decodedData.forEach((id, product) {
      final prodTemp = ProductModel.fromJson(product);
      prodTemp.id = id;

      products.add(prodTemp);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_url/products/$id.json';
    await http.delete(url);

    return 1;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dojzr8wxw/image/upload?upload_preset=vfwkxg0f');
    final mimeType = mime(image.path).split('/'); //  image/jpeg

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(
        mimeType[0],
        mimeType[1],
      ),
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if(response.statusCode != 200 && response.statusCode != 201) {
      print('Algo salio mal');
      print(response.body);
      return null;
    }

    final responseData = json.decode(response.body);
    print(responseData);
    return responseData['secure_url'];
  }
}
