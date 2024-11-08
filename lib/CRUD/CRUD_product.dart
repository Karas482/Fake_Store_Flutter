import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CRUDProductForm extends StatefulWidget {
  @override
  _CRUDProductFormState createState() => _CRUDProductFormState();
}

class _CRUDProductFormState extends State<CRUDProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  List<Map<String, dynamic>> products = [];
  int? selectedProductId;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/products/'));
      if (response.statusCode == 200) {
        setState(() {
          products = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSubmitting = true;
      });

      final productData = {
        'title': _titleController.text,
        'category': _categoryController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'image': _imageController.text,
        'description': _descriptionController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:5000/products'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(productData),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product created successfully!')),
          );
          _fetchProducts();
          _clearForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create product: ${response.body}')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $error')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _updateProduct() async {
    if (selectedProductId != null && selectedProductId! > 0) {
      final productData = {
        'title': _titleController.text.trim(),
        'category': _categoryController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'image': _imageController.text.trim(),
        'description': _descriptionController.text.trim(),
      };

      try {
        final response = await http.put(
          Uri.parse('http://127.0.0.1:5000/products/$selectedProductId'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(productData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product updated successfully!')),
          );
          _fetchProducts();
          _clearForm();
        } else {
          final errorMsg = json.decode(response.body)['error'] ?? 'Failed to update product';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update product: $errorMsg')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $error')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No product selected for updating')),
      );
    }
  }


  Future<void> _deleteProduct(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:5000/products/$productId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully!')),
        );
        _fetchProducts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  void _clearForm() {
    setState(() {
      _formKey.currentState!.reset();
      _titleController.clear();
      _categoryController.clear();
      _priceController.clear();
      _imageController.clear();
      _descriptionController.clear();
      selectedProductId = null;
    });
  }

  void _selectProduct(Map<String, dynamic> product) {
    setState(() {
      selectedProductId = product['id'];
      _titleController.text = product['title'];
      _categoryController.text = product['category'];
      _priceController.text = product['price'].toString();
      _imageController.text = product['image'];
      _descriptionController.text = product['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Products")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                  ),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                    validator: (value) => value!.isEmpty ? 'Please enter a category' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter a price';
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Please enter a valid positive number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _imageController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                    validator: (value) => value!.isEmpty ? 'Please enter an image URL' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        child: Text('Create Product'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: (_isSubmitting || selectedProductId == null) ? null : _updateProduct,
                        child: Text('Update Product'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _clearForm,
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: products.isEmpty
                  ? Center(child: Text('No products available'))
                  : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product['title']),
                    subtitle: Text('Category: ${product['category']} - Price: ${product['price']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteProduct(product['id']),
                    ),
                    onTap: () => _selectProduct(product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
