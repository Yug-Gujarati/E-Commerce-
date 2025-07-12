import 'package:e_commerce/view_model/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../model/cart_model.dart';
import '../model/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final double price;
  final double rating;
  final int ratingCount;

  const ProductDetailScreen({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.ratingCount,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedQuantity = 1;
  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;
  bool isFavorite = false;

  Color selectedColor = Colors.red;
  String selectedSize = 'M';
  // Remove the late Product product; declaration - we don't need it

  final List<Color> availableColors = [
    Colors.red,
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Custom App Bar
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
                        'Product Details',
                        style: TextStyle(
                          fontSize: 50.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Color(0xFFf6f6f6),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black,
                            size: 60.sp,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Container(
                          width: double.infinity,
                          height: 800.h,
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: Color(0xFFf5f5f5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              widget.image,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    size: 100.sp,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),

                        // Product Details
                        Padding(
                          padding: EdgeInsets.only(left: 40.w, right: 40.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and Price
                              Text(
                                widget.title,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 60.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 10.w),
                              Text(
                                '\$${widget.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 60.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),

                              SizedBox(height: 20.h),

                              // Rating
                              Row(
                                children: [
                                  SizedBox(width: 10.w),
                                  Container(

                                    padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 10.w),
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(20)

                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.white, size: 15,),
                                        SizedBox(width: 5.w,),
                                        Text(
                                          '${widget.rating.toStringAsFixed(1)}',
                                          style: TextStyle(
                                            fontSize: 40.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    '(${widget.ratingCount} reviews)',
                                    style: TextStyle(
                                      fontSize: 35.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 30.h),

                              // Color Selection
                              Text(
                                'Color',
                                style: TextStyle(
                                  fontSize: 50.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: availableColors.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Color color = entry.value;
                                  bool isSelected = selectedColorIndex == index;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedColorIndex = index;
                                        selectedColor = color; // Update the selected color
                                      });
                                    },
                                    child: Container(
                                      width: 100.w,
                                      height: 100.w,
                                      margin: EdgeInsets.only(right: 15.w),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                        border: isSelected
                                            ? Border.all(color: color, width: 4.w)
                                            : Border.all(color: Colors.grey.shade300, width: 2.w),
                                      ),
                                      padding: EdgeInsets.all(isSelected ? 8.w : 4.w),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                              SizedBox(height: 30.h),

                              // Description
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 50.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Text(
                                widget.description,
                                style: TextStyle(
                                  fontSize: 40.sp,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),



                              SizedBox(height: 30.h),

                              SizedBox(height: 40.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Buttons
                Container(
                  width: 980.w,
                  height: 150.h,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Row(
                    children: [
                      // Add to Cart Button
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (selectedQuantity > 1) {
                                  setState(() {
                                    selectedQuantity--;
                                  });
                                }
                              },
                              child: Container(
                                width: 100.w,
                                height: 120.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 50.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Container(
                              width: 150.w,
                              height: 100.w,

                              child: Center(
                                child: Text(
                                  selectedQuantity.toString(),
                                  style: TextStyle(
                                    fontSize: 50.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedQuantity++;
                                });
                              },
                              child: Container(
                                width: 100.w,
                                height: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 50.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 15.w),

                      // Buy Now Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final cartItem = CartItem(
                              id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a unique ID
                              image: widget.image,
                              title: widget.title,
                              price: widget.price,
                              selectedColor: selectedColor,
                              quantity: selectedQuantity,
                            );

                            await CartService.addToCart(cartItem);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added to cart!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            height: 110.h,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                'Add to cart',
                                style: TextStyle(
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 20.h,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}