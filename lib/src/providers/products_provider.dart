import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:form_validation/src/models/product_model.dart';

class ProductsProvider {
  final String _url = 'https://flutter-course-5b319-default-rtdb.firebaseio.com';

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/products.json';
    final response = await http.post(url, body: productModelToJson(product));

    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }
}