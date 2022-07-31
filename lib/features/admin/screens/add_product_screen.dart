import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productQuantityController =
      TextEditingController();

  String? _category = '';
  List<File> images = [];

  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
  ];

  void selectImages() async {
    var result = await pickImages();
    setState(() {
      images.addAll(result);
    });
  }

  removeSelectedImage(int index) async {
    setState(() {
      images.removeAt(index);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _productNameController.dispose();
    _productDescController.dispose();
    _productPriceController.dispose();
    _productQuantityController.dispose();
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
            centerTitle: true,
            title: Text(
              'Add Product',
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
      body: SingleChildScrollView(
          child: Form(
              child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: selectImages,
              child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  dashPattern: [10, 5],
                  strokeCap: StrokeCap.round,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open_outlined,
                          size: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Select Product Images',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade400,
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: images.isNotEmpty
                  ? GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          crossAxisCount: 3),
                      itemCount: images.length,
                      itemBuilder: (contex, index) {
                        return Stack(children: [
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: (() => showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.all(10),
                                        title: Container(
                                          decoration: BoxDecoration(),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.file(
                                            images[index],
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ))),
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: 150,
                                  child: Image.file(
                                    images[index],
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                                onTap: (() => removeSelectedImage(index)),
                                child: Icon(
                                  Icons.cancel_outlined,
                                  size: 24,
                                )),
                          )
                        ]);
                      })
                  // CarouselSlider(
                  //     items: images.map((i) {
                  //       return Builder(
                  //           builder: (BuildContext context) => Image.file(
                  //                 i,
                  //                 fit: BoxFit.cover,
                  //                 height: 200,
                  //               ));
                  //     }).toList(),
                  //     options: CarouselOptions(
                  //       viewportFraction: 0.6,
                  //       height: 200,
                  //       autoPlay: true,
                  //     ),
                  //   )
                  : null,
            ),
            SizedBox(height: 30),
            CustomTextField(
                controller: _productNameController, hintText: 'Product name'),
            SizedBox(height: 10),
            CustomTextField(
              controller: _productDescController,
              hintText: 'Description',
              maxLines: 5,
            ),
            SizedBox(height: 10),
            CustomTextField(
              controller: _productPriceController,
              hintText: 'Price',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            CustomTextField(
              controller: _productQuantityController,
              hintText: 'Quantity',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: DropdownButton(
                  isExpanded: true,
                  hint: Text('Select Category'),
                  icon: Icon(Icons.arrow_drop_down_rounded),
                  items: productCategories.map((String item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  value: _category == '' ? null : _category,
                  onChanged: (String? newVal) {
                    setState(() {
                      _category = newVal!;
                    });
                  }),
            ),
            SizedBox(height: 30),
            CustomButton(text: 'Sell', onTap: () {})
          ],
        ),
      ))),
    );
  }
}
