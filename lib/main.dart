import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products {
  final String title;
  final String price;
  final String imageUrl;

  Products({required this.title, required this.price, required this.imageUrl});
}

class Searchhh {
  final List<Products> products;

  Searchhh({required this.products});

  factory Searchhh.fromJson(Map<String, dynamic> json) {
    List<Products> productList = [];
    for (var product in json['products']) {
      productList.add(Products(
        title: product['title'],
        price: product['price'],
        imageUrl: product['imageUrl'],
      ));
    }
    return Searchhh(products: productList);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Product Categories'),
        ),
        body: CategoryListScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CategoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListScreen(category: 'electronics'),
              ),
            );
          },
          child: Text('Electronics'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListScreen(category: 'clothing'),
              ),
            );
          },
          child: Text('Clothing'),
        ),
        // Add more categories as needed
      ],
    );
  }
}

class ProductListScreen extends StatefulWidget {
  final String category;

  ProductListScreen({required this.category});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Products> _products = [];

  @override
  void initState() {
    super.initState();
    _getProducts(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products - ${widget.category}'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_products[index].title.toString()),
            subtitle: Text(_products[index].price.toString()),
            leading: Image.network(
              _products[index].imageUrl,
              height: 50.0,
              width: 50.0,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Future<void> _getProducts(String category) async {
    // Adjust the API endpoint based on the selected category
    String apiUrl = 'https://dummyjson.com/products/category/$category';
    var response = await http.get(Uri.parse(apiUrl));
    var jsonResponse = jsonDecode(response.body.toString());
    var res = Searchhh.fromJson(jsonResponse);
    var list = res.products;
    setState(() {
      _products = list ?? [];
    });
  }
}
