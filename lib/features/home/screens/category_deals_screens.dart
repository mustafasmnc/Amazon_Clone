import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  final HomeServices homeServices = HomeServices();
  List<Product>? productList;

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  fetchCategoryProducts() async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: widget.category,
    );
    setState(() {});
  }

  navigatoToProductDetails(Product product) {
    Navigator.pushNamed(context, ProductDetailScreen.routeName,
        arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
            backgroundColor: Color.fromARGB(255, 125, 221, 216),
            elevation: 0,
            flexibleSpace: Container(
              decoration:
                  BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Text(
              widget.category,
              style: TextStyle(color: Colors.black),
            )),
      ),
      body: productList == null
          ? CustomLoader()
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Keep shopping for ${widget.category}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 15),
                      itemCount: productList!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.4,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final product = productList![index];
                        return GestureDetector(
                          onTap: () => navigatoToProductDetails(product),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 130,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.black12,
                                    width: 0.5,
                                  )),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: CarouselSlider(
                                      items: product.images.map((i) {
                                        return Builder(
                                            builder: (BuildContext context) =>
                                                Image.network(
                                                  i,
                                                  fit: BoxFit.cover,
                                                  height: 200,
                                                ));
                                      }).toList(),
                                      options: CarouselOptions(
                                        viewportFraction: 1,
                                        height: 200,
                                        autoPlay: false,
                                      ),
                                    ),
                                    // child: Image.network(
                                    //   product.images[0],
                                    // ),
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(
                                    left: 0,
                                    top: 5,
                                    right: 15,
                                  ),
                                  child: Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 16),
                                  ))
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
    );
  }
}
