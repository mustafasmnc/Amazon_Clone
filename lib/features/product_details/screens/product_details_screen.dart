import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  TextEditingController _searchQuery = TextEditingController();
  final CarouselController _controller = CarouselController();
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  int _currentImage = 0;
  double avgRating = 0;
  double myRating = 0;

  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }

    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
      arguments: query,
    );
  }

  void addToCart() {
    productDetailsServices.addToCart(
      context: context,
      product: widget.product,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchQuery.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 125, 221, 216),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                    height: 42,
                    margin: EdgeInsets.only(left: 15),
                    child: Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        controller: _searchQuery,
                        onFieldSubmitted: navigateToSearchScreen,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () =>
                                  navigateToSearchScreen(_searchQuery.text),
                              child: Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.search_outlined,
                                  color: Colors.black,
                                  size: 23,
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.only(top: 10, left: 10),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide(
                                color: Colors.black38,
                                width: 1,
                              ),
                            ),
                            hintText: 'Search Product',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            )),
                      ),
                    )),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(
                  Icons.mic_outlined,
                  color: Colors.black,
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.product.id!),
                Stars(rating: avgRating),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(widget.product.name, style: TextStyle(fontSize: 18)),
          ),
          CarouselSlider(
            items: widget.product.images.map((i) {
              return Builder(
                  builder: (BuildContext context) => Image.network(
                        i,
                        fit: BoxFit.contain,
                        height: 200,
                      ));
            }).toList(),
            carouselController: _controller,
            options: CarouselOptions(
                viewportFraction: 1,
                height: 300,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentImage = index;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.product.images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_currentImage == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          Container(
            color: Colors.black12,
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Deal Price: ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '\$${widget.product.price}',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ]),
                ),
                Text(widget.product.description)
              ],
            ),
          ),
          Container(
            color: Colors.black12,
            height: 5,
          ),
          widget.product.quantity > 0
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      CustomButton(text: 'Buy Now', onTap: () {}),
                      SizedBox(height: 20),
                      CustomButton(
                        text: 'Add to Cart',
                        color: Color.fromRGBO(254, 216, 19, 1),
                        onTap: addToCart,
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    'Currrently unavaliable',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
          Container(
            color: Colors.black12,
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rate The Product',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                RatingBar.builder(
                    initialRating: myRating,
                    maxRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2),
                    allowHalfRating: true,
                    itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: GlobalVariables.secondaryColor,
                        ),
                    onRatingUpdate: (rating) {
                      productDetailsServices.rateProduct(
                        context: context,
                        product: widget.product,
                        rating: rating,
                      );
                    })
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
