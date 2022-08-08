import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalRating = 0;
    for (int i = 0; i < product.rating!.length; i++) {
      totalRating += product.rating![i].rating;
    }
    double avgRating = 0;
    if (totalRating != 0) {
      avgRating = totalRating / product.rating!.length;
    }
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
                    autoPlay: false,
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
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Stars(rating: avgRating),
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
        )
      ],
    );
  }
}
