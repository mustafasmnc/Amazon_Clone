import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/cart/services/cart_services.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/home/widgets/carousel_image.dart';
import 'package:amazon_clone/features/home/widgets/deal_of_day.dart';
import 'package:amazon_clone/features/home/widgets/top_categories.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchQuery = TextEditingController();
  final CartServices cartServices = CartServices();

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
      arguments: query,
    );
  }

  @override
  void initState() {
    super.initState();
    cartServices.checkProductInCart(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    _searchQuery.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
        child: Column(
          children: const [
            AddressBox(),
            SizedBox(height: 10),
            TopCategories(),
            SizedBox(height: 10),
            CarouselImage(),
            SizedBox(height: 10),
            DealOfDay(),
          ],
        ),
      ),
    ));
  }
}
