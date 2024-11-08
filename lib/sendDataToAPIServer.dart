import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreateProductScreen(),
    );
  }
}

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> sendData() async {
    // API URL
    String apiUrl = 'http://127.0.0.1:5000/create_product';  // Update to match your actual endpoint

    // Prepare the body (JSON data)
    Map<String, dynamic> body = {
      'title': _titleController.text,
      'category': _categoryController.text,
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'image': _imageController.text,
      'description': _descriptionController.text,
    };

    // Make a POST request
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      // Successfully sent data
      print("Product added: ${response.body}");
      _clearFields();  // Clear fields after successful addition
    } else {
      // Error occurred
      print("Failed: ${response.statusCode}");
    }
  }

  // Function to clear input fields
  void _clearFields() {
    _titleController.clear();
    _categoryController.clear();
    _priceController.clear();
    _imageController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Product"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Product Title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
            ),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                prefixIcon: Icon(Icons.money),
              ),
            ),
            TextFormField(
              controller: _imageController,
              decoration: InputDecoration(
                labelText: 'Image URL',
                prefixIcon: Icon(Icons.image),
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: sendData,
              child: Text("Save"),
            ),
            ElevatedButton(
              onPressed: _clearFields,
              child: Text("Clear"),
            ),
          ],
        ),
      ),
    );
  }
}
