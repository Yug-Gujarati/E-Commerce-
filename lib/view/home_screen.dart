import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/utils/my_text.dart';
import 'package:e_commerce/view/product_detail_screen.dart';
import 'package:e_commerce/view_model/get_all_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();
  int _currentIndex = 0;

  Map<int, Color> selectedColors = {};

  List<String> categorys = [
    "assets/men's clothing.jpg",
    "assets/jewelery.jpg",
    "assets/women's clothing.jpg",
    "assets/electronics.jpg",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetAllDataProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<GetAllDataProvider>(context);
    final List<String> categories = productProvider.categories;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(left: 30.w, right:30.w),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFf6f6f6),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings, color: Colors.black),
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: Color(0xFFf6f6f6),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Search bar
              Container(
                width: double.infinity,
                height: 120.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFf6f6f6),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: 1,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          icon: const Icon(Icons.search, color: Colors.black),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'medium',
                          fontSize: 40.sp,
                        ),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      width: 2.w,
                      color: Colors.black,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.tune, color: Colors.black),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 50.h),
                    child: Column(
                      children: [
                        // Header with settings and notifications

                        SizedBox(height: 20.h),

                        // Carousel slider
                        carouselSlider(),

                        SizedBox(height: 30.h),

                        // Categories section
                        SizedBox(
                          height: 250.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productProvider.categories.length,
                            itemBuilder: (context, index) {
                              final category = productProvider.categories[index];
                              final imagePath = categorys[index];
                              return GestureDetector(
                                onTap: () {

                                },
                                child: Container(
                                  width: 160.w,
                                  margin: EdgeInsets.symmetric(horizontal: 50.w),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 120.h,
                                        width: 120.h,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFf5f5f5),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(imagePath),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        category,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Products grid
                        productProvider.isLoading
                            ? Container(
                          height: 400.h,
                          child: const Center(child: CircularProgressIndicator()),
                        )
                            : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            childAspectRatio: 2 / 3,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: productProvider.products.length,
                          itemBuilder: (context, index) {
                            final Product product = productProvider.products[index];
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context)=>
                                            ProductDetailScreen(
                                                image: product.image,
                                                title: product.title,
                                                description: product.description,
                                                price: product.price,
                                                rating: product.rating,
                                                ratingCount: product.ratingCount
                                            )
                                    )
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 20.w, right: 20.w),
                                decoration: BoxDecoration(
                                  color: Color(0xFFf5f5f5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        height: 80.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.favorite_border,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 60.h,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Image.network(
                                                product.image,
                                                height: 150.h,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Expanded(
                                              child: MyText(
                                                text: product.title,
                                                fontSize: 40.sp,
                                                fontWeight: FontWeight.w500,
                                                textColor: Colors.black,
                                                width: 320,
                                                maxline: 3,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                MyText(
                                                  text: "\$${product.price}",
                                                  fontSize: 35.sp,
                                                  fontWeight: FontWeight.bold,
                                                  textColor: Colors.black,
                                                  width: 150,
                                                  maxline: 6,
                                                ),
                                                Row(
                                                  children: [
                                                    buildColorOption(Colors.red, index),
                                                    SizedBox(width: 10.w),
                                                    buildColorOption(Colors.black, index),
                                                    SizedBox(width: 10.w),
                                                    buildColorOption(Colors.blue, index),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),


                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Bottom Navigation Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.grid_view_rounded, 'Home', 0),
                _buildNavItem(Icons.favorite_border, 'Search', 1),
                const SizedBox(width: 80), // Space for center button
                _buildNavItem(Icons.shopping_cart, 'My Cart', 3),
                _buildNavItem(Icons.person, 'Profile', 4),
              ],
            ),
            // Center Floating Button
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: Container(
                width: 150.w,
                height: 150.h,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    // Navigate to Add screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColorOption(Color color, int index) {
    bool isSelected = selectedColors[index] == color;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColors[index] = color;
        });
      },
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: isSelected
              ? Border.all(color: color, width: 4.w)
              : Border.all(color: Colors.black, width: 1.w),
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
  }

  Widget carouselSlider() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFf5f5f5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CarouselSlider(
            items: categorys.map((imagePath) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        width: 430.w,
                        child: Text(
                          "Super sale discount up to 50% off",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 50.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        width: 250.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            "Shop Now",
                            style: TextStyle(color: Colors.white, fontSize: 40.sp),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 100.w),
                  Container(
                    width: 200.w,
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
            options: CarouselOptions(
              height: 400.h,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 16 / 9,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: categorys.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? Colors.black
                        : Colors.grey.shade400,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });

        // Navigate to different screens based on index
        switch (index) {
          case 0:
            break;
          case 1:
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
            break;
          case 4:
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color:  Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color:   Colors.grey,
              fontSize: 12,
              fontWeight:  FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Example screens for navigation (you'll need to create these)
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Text('Search Screen'),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Text('Favorites Screen'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Text('Add Screen'),
      ),
    );
  }
}