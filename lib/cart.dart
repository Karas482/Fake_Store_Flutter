import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatelessWidget {
  final int user_id;

  // Constructor to accept data
  CartScreen({required this.user_id});

  // Fetch product details from the API based on the user ID
  Future<List> _getCartProducts() async {
    var url = Uri.parse("https://fakestoreapi.com/carts/user/${this.user_id}");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)[0]['products'];
      return data; // Return a list of products
    } else {
      throw Exception('Failed to load cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List>(
              future: _getCartProducts(), // Fetch cart data asynchronously
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 5,
                    ),
                  ); // Loading spinner
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}')); // Error handling
                } else if (snapshot.hasData && snapshot.data != null) {
                  // Display the list of products in the cart
                  return Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              var product = snapshot.data![index];
                              return Container(
                                width: double.infinity,
                                height: 100,
                                child: ListTile(
                                  leading: Image.network(
                                    "https://fakestoreapi.com/img/${product['productId']}.jpg",
                                    fit: BoxFit.contain,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                  title: Text("Product ID: ${product['productId']}"),
                                  subtitle: Text("Quantity: ${product['quantity']}"),
                                  trailing: IconButton(
                                    onPressed: () {
                                      // Implement the delete functionality here
                                    },
                                    icon: Icon(Icons.delete_forever_outlined, size: 20,),
                                    color: Colors.redAccent,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(),
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Total Amount: \$100.0", // You can calculate this based on the cart data
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent,
                                          fontSize: 20),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      "Total Items: ${snapshot.data!.length}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                          fontSize: 18),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Implement checkout functionality here
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ))),
                                  child: const Text(
                                    "Checkout",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  ); // Display fetched data
                } else {
                  return Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
