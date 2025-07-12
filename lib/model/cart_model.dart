import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String image;
  final String title;
  final double price;
  final Color selectedColor;
  int quantity;

  CartItem({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.selectedColor,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'price': price,
      'selectedColor': selectedColor.value,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      price: json['price'].toDouble(),
      selectedColor: Color(json['selectedColor']),
      quantity: json['quantity'],
    );
  }
}