import 'dart:convert';

import 'package:fake_store/form.dart';
import 'package:fake_store/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import 'package:fake_store/CRUD/CRUD_product.dart';


import 'detail.dart';
import 'product_list.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          actions: [
            Padding(
              padding: EdgeInsets.only(left: 0, right: 10, top: 10),
              child: IconButton(onPressed:(){}, icon: Icon(Icons.point_of_sale_outlined)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0, right: 10, top: 10),
              child: badges.Badge(
                badgeContent: Text(
                  "50",
                  style: TextStyle(fontSize: 10, color: Colors.yellow),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(5),
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                  elevation: 10,
                ),
                onTap: () {
                },
                child: Icon(Icons.notifications),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                  accountName: Text(
                    "Sarak",
                  ),
                  accountEmail: Text("Tenseijinchuriki@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        "https://i.pinimg.com/736x/b6/dc/49/b6dc493f3fd8bb0b7b3c0199ee0cceb5.jpg"),
                  )),
              ListTile(
                leading: const Icon(
                  Icons.list_alt_outlined,
                  size: 50,
                ),
                title:
                    const Text("Product List", style: TextStyle(fontSize: 18)),
                subtitle: const Text("display all product item..."),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProductList()));
                },
              ),
              // In your Dashboard widget's Drawer

              ListTile(
                leading: const Icon(
                  Icons.manage_accounts_outlined,
                  size: 50,
                ),
                title: const Text(
                    "Profile",
                    style: TextStyle(fontSize: 18)
                ),
                subtitle: const Text("view or edit your profile"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfile(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add, size: 50),
                title: Text("Manage Product", style: TextStyle(fontSize: 18)),
                subtitle: Text("CRUD product to the store"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CRUDProductForm()),
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.contact_page_outlined,
                  size: 50,
                ),
                title: const Text(
                  "Contact",
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: const Text("contact our team while issue"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailScreen(data: 1)));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.login_rounded,  // Changed to login icon
                  size: 50,
                ),
                title: const Text(
                  "Login",  // Changed title to "Login"
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: const Text("Access your account..."),  // Updated subtitle
                onTap: () {
                  Navigator.push(
                    context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),

              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Version 1.0",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: const Card(
                        child: SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              Icon(
                                Icons.point_of_sale,
                                size: 70,
                                color: Colors.greenAccent,
                              ),
                              Text(
                                "POINT OF SALE",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductList()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      child: const Card(
                        child: SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              Icon(
                                Icons.list_alt_outlined,
                                size: 70,
                                color: Colors.lightBlue,
                              ),
                              Text(
                                "Product List",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductList()));
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
