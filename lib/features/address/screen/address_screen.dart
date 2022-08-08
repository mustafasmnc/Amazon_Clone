import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _flatBuildingController = TextEditingController();
  final TextEditingController _areaStreetController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _townCityController = TextEditingController();

  final _addressFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _flatBuildingController.dispose();
    _areaStreetController.dispose();
    _pincodeController.dispose();
    _townCityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
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
            ],
          ),
        ),
      ),
    );
  }
}
