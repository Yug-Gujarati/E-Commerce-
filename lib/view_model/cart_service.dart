import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/cart_model.dart';

class CartService {
  static const String _cartKey = 'cart_items';

  static Future<void> addToCart(CartItem item) async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItem> cartItems = await getCartItems();

    int existingIndex = cartItems.indexWhere((cartItem) =>
    cartItem.id == item.id &&
        cartItem.selectedColor.value == item.selectedColor.value );

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity += item.quantity;
    } else {
      cartItems.add(item);
    }

    await _saveCartItems(cartItems);
  }

  static Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(_cartKey);

    if (cartJson == null) return [];

    final List<dynamic> cartList = json.decode(cartJson);
    return cartList.map((item) => CartItem.fromJson(item)).toList();
  }

  static Future<void> updateQuantity(
      String id, Color color, int newQuantity) async {
    List<CartItem> cartItems = await getCartItems();

    int index = cartItems.indexWhere((item) =>
    item.id == id &&
        item.selectedColor.value == color.value );

    if (index != -1) {
      if (newQuantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].quantity = newQuantity;
      }
      await _saveCartItems(cartItems);
    }
  }

  static Future<void> removeItem(String id, Color color) async {
    List<CartItem> cartItems = await getCartItems();
    cartItems.removeWhere((item) =>
    item.id == id &&
        item.selectedColor.value == color.value);
    await _saveCartItems(cartItems);
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  static Future<void> _saveCartItems(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final String cartJson =
    json.encode(cartItems.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, cartJson);
  }

  static Future<double> getTotalPrice() async {
    List<CartItem> cartItems = await getCartItems();
    return cartItems.fold<double>(
        0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  static Future<int> getTotalItems() async {
    List<CartItem> cartItems = await getCartItems();
    return cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}
