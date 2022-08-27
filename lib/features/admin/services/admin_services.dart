import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
//import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdminServices {
  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  //add product
  void sellProduct(
      {required BuildContext context,
      required String name,
      required String description,
      required double price,
      required double quantity,
      required String category,
      required List<File> images}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // we are using cloudinary for saving images to cloud because of free mongoodb gives only 500MB capacity
      //final cloudinary = CloudinaryPublic('smnc', 'aqbfluda');
      final cloudinary = Cloudinary.full(
        apiKey: dotenv.env['CloudinaryApiKey']!,
        apiSecret: dotenv.env['CloudinaryApiSecret']!,
        cloudName: dotenv.env['CloudinaryCloudName']!,
      );
      List<String> imageUrls = [];

      for (var i = 0; i < images.length; i++) {
        // CloudinaryResponse response = await cloudinary.uploadFile(
        //   CloudinaryFile.fromFile(images[i].path, folder: name),
        // );
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(now);
        var finalFormettedData = formatted.replaceAll('-', '_');
        var fileName =
            '${name}_${i}_${finalFormettedData}_${getRandomString(10)}';
        //we are setting image name to name_count_date_randomtext,
        //ie: television_0_2022_08_02_Yg6irwraZA, television_1_2022_08_02_Z6l2R8YeW0

        final CloudinaryResponse cloudinaryResponse =
            await cloudinary.uploadResource(CloudinaryUploadResource(
          filePath: images[i].path,
          fileBytes: images[i].readAsBytesSync(),
          resourceType: CloudinaryResourceType.image,
          folder: name,
          fileName: fileName,
        ));

        imageUrls.add(cloudinaryResponse.url!);
      }

      Product product = Product(
        name: name,
        description: description,
        category: category,
        quantity: quantity,
        price: price,
        images: imageUrls,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
        body: product.toJson(),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackbar(context, 'Product added successfully!');
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackbar(context, e.toString());
      print(e.toString());
    }
  }

  //get all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(response.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(jsonDecode(response.body)[i]),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
      print(e.toString());
    }

    return productList;
  }

  //delete product
  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response response = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      if (response.statusCode == 200) {
        final cloudinary = Cloudinary.full(
          apiKey: dotenv.env['CloudinaryApiKey']!,
          apiSecret: dotenv.env['CloudinaryApiSecret']!,
          cloudName: dotenv.env['CloudinaryCloudName']!,
        );
        for (var i = 0; i < product.images.length; i++) {
          // var asd = product.images[i];
          // var dsa = asd.split('/');
          // var qqq = '${dsa[dsa.length - 2]}' + '${dsa[dsa.length - 1]}';
          // print('publicid: $qqq');
          final CloudinaryResponse cloudinaryResponse =
              await cloudinary.deleteResource(
            //publicId: qqq,
            resourceType: CloudinaryResourceType.image,
            url: product.images[i],
            invalidate: true,
          );
        }
      }

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            onSuccess();
            showSnackbar(context, 'Product deleted successfully!');
          });
    } catch (e) {
      showSnackbar(context, e.toString());
      print(e.toString());
    }
  }

  //get all orders
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(response.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(jsonDecode(response.body)[i]),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
      print(e.toString());
    }

    return orderList;
  }

  //change order status
  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response response = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackbar(context, e.toString());
      print(e.toString());
    }
  }

  //get all orders
  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/admin/analytics'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          var res = jsonDecode(response.body);
          totalEarning = res['totalEarnings'];
          sales = [
            Sales('Mobiles', res['mobileEarnings']),
            Sales('Essentials', res['essentialEarnings']),
            Sales('Appliances', res['applianceEarnings']),
            Sales('Books', res['bookEarnings']),
            Sales('Fashion', res['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
      print(e.toString());
    }

    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }
}
