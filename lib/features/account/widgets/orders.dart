import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final AccountServices accountServices = AccountServices();
  List<Order>? orders;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const CustomLoader()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Your Orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 16,
                        color: GlobalVariables.selectedNavBarColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
              // display orders
              Container(
                height: 170,
                padding: EdgeInsets.only(left: 10, top: 20, right: 0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orders!.length,
                    itemBuilder: ((context, index) {
                      return SingleProduct(
                        image: orders![index].products[0].images[0],
                      );
                    })),
              )
            ],
          );
  }
}
