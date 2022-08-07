import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({Key? key, required this.index}) : super(key: key);

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();

  void increaseQuantity(Product product) {
    productDetailsServices.addToCart(
      context: context,
      product: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              SizedBox(
                height: 130,
                width: 130,
                child: CarouselSlider(
                  items: product.images.map((i) {
                    return Builder(
                        builder: (BuildContext context) => Image.network(
                              i,
                              fit: BoxFit.contain,
                              height: 130,
                            ));
                  }).toList(),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 130,
                    autoPlay: true,
                  ),
                ),
              ),
              // Image.network(
              //   product.images[0],
              //   height: 130,
              //   width: 130,
              //   fit: BoxFit.contain,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 230,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.name,
                      maxLines: 2,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    width: 230,
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    child: Text(
                      '\$${product.price}',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 230,
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Eligible for FREE shipping',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    width: 230,
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      'In Stock',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black12),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 32,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.remove_outlined,
                        size: 18,
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black12,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(0)),
                      child: Container(
                          width: 35,
                          height: 32,
                          alignment: Alignment.center,
                          child: Text(quantity.toString())),
                    ),
                    InkWell(
                      onTap: () => increaseQuantity(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.add_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
