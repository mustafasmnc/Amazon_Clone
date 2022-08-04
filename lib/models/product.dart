import 'dart:convert';

import 'package:amazon_clone/models/rating.dart';

class Product {
  String? id;
  final String name;
  final String description;
  final String category;
  final double quantity;
  final double price;
  final List<String> images;
  final List<Rating>? rating;
  Product({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.quantity,
    required this.price,
    required this.images,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    result.addAll({'name': name});
    result.addAll({'description': description});
    result.addAll({'category': category});
    result.addAll({'quantity': quantity});
    result.addAll({'price': price});
    result.addAll({'images': images});
    result.addAll({'rating': rating});

    return result;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      price: map['price']?.toDouble() ?? 0.0,
      images: List<String>.from(map['images']),
      rating: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
