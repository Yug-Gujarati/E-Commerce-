import 'package:e_commerce/view_model/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];
  bool isLoading = true;
  double totalPrice = 0.0;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final items = await CartService.getCartItems();
      final price = await CartService.getTotalPrice();
      final itemCount = await CartService.getTotalItems();

      setState(() {
        cartItems = items;
        totalPrice = price;
        totalItems = itemCount;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading cart: $e')),
      );
    }
  }

  Future<void> _updateQuantity(CartItem item, int newQuantity) async {
    await CartService.updateQuantity(
      item.id,
      item.selectedColor,
      newQuantity,
    );
    _loadCartItems();
  }

  Future<void> _removeItem(CartItem item) async {
    await CartService.removeItem(
      item.id,
      item.selectedColor
    );
    _loadCartItems();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item removed from cart'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _clearCart() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cart'),
        content: Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await CartService.clearCart();
              Navigator.pop(context);
              _loadCartItems();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cart cleared'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFf6f6f6),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 60.sp,
                      ),
                    ),
                  ),
                  Text(
                    'My Cart',
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                   SizedBox(width: 100.w,)
                ],
              ),
            ),

            // Cart Content
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : cartItems.isEmpty
                  ? _buildEmptyCart()
                  : _buildCartList(),
            ),

            // Bottom Total and Checkout
            if (cartItems.isNotEmpty) _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 200.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 40.h),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 60.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Add some items to get started',
            style: TextStyle(
              fontSize: 40.sp,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 60.h),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Start Shopping',
                style: TextStyle(
                  fontSize: 45.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return _buildCartItem(item);
      },
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Color(0xFFf5f5f5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(item.image),
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(width: 20.w),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),


                // Color and Size

                SizedBox(height: 15.h),

                // Price and Quantity Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.grey)
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _updateQuantity(item, item.quantity - 1),
                            child: Container(
                              width: 70.w,
                              height: 70.w,

                              child: Icon(
                                Icons.remove,
                                color: Colors.black,
                                size: 40.sp,
                              ),
                            ),
                          ),

                          SizedBox(width: 15.w),

                          Text(
                            item.quantity.toString(),
                            style: TextStyle(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(width: 15.w),

                          GestureDetector(
                            onTap: () => _updateQuantity(item, item.quantity + 1),
                            child: Container(
                              width: 70.w,
                              height: 70.w,
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 40.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),

          // Remove Button
          GestureDetector(
            onTap: () => _removeItem(item),
            child: Container(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 50.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Total Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 50.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 60.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Checkout Button
          GestureDetector(
            onTap: () {
              // Checkout functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Proceeding to checkout...'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 50.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
