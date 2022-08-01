import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
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
      final cloudinary = CloudinaryPublic('smnc', 'aqbfluda');
      List<String> imageUrls = [];

      for (var i = 0; i < images.length; i++) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );

        imageUrls.add(response.secureUrl);
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
    }
  }
}
