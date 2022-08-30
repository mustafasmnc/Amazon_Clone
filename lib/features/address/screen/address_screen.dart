import 'dart:io' show Platform;

import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _flatBuildingController = TextEditingController();
  final TextEditingController _areaStreetController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _townCityController = TextEditingController();

  final _addressFormKey = GlobalKey<FormState>();
  String addressToBeUsed = "";
  final AddressServices addressServices = AddressServices();

  List<PaymentItem> paymentItems = [];

  @override
  void initState() {
    super.initState();
    paymentItems.add(PaymentItem(
      amount: widget.totalAmount,
      label: 'Total Amount',
      status: PaymentItemStatus.final_price,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _flatBuildingController.dispose();
    _areaStreetController.dispose();
    _pincodeController.dispose();
    _townCityController.dispose();
  }

  void onApplePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";
    bool isForm = _flatBuildingController.text.isNotEmpty ||
        _areaStreetController.text.isNotEmpty ||
        _pincodeController.text.isNotEmpty ||
        _townCityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${_flatBuildingController.text}, ${_areaStreetController.text}, ${_pincodeController.text}, ${_townCityController.text} - ${_pincodeController.text}';
      } else {
        throw Exception('Please enter all values!');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackbar(context, 'Error!');
    }
    //  addressServices.placeOrder(
    //     context: context,
    //     address: addressToBeUsed,
    //     totalSum: double.parse(widget.totalAmount),
    //   );
    //print(addressToBeUsed);
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 125, 221, 216),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          address,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'OR',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              Form(
                  key: _addressFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _flatBuildingController,
                        hintText: 'Flat, House No, Building',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _areaStreetController,
                        hintText: 'Area, Street',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _pincodeController,
                        hintText: 'Pincode',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _townCityController,
                        hintText: 'Town/City',
                      ),
                      SizedBox(height: 10),
                    ],
                  )),
              Platform.isAndroid
                  ? GooglePayButton(
                      onPressed: () => payPressed(address),
                      width: size.width / 2,
                      height: 50,
                      paymentConfigurationAsset: 'gpay.json',
                      onPaymentResult: onGooglePayResult,
                      paymentItems: paymentItems,
                      style: GooglePayButtonStyle.black,
                      type: GooglePayButtonType.buy,
                      margin: const EdgeInsets.only(top: 15.0),
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ApplePayButton(
                      onPressed: () => payPressed(address),
                      paymentConfigurationAsset: 'applepay.json',
                      onPaymentResult: onApplePayResult,
                      paymentItems: paymentItems,
                      style: ApplePayButtonStyle.black,
                      type: ApplePayButtonType.buy,
                      margin: const EdgeInsets.only(top: 15.0),
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
