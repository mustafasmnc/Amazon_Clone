import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType keyboardType;
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.maxLines = 1,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.hintText == 'Password' ? showPassword : false,
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                  widget.hintText == 'Password' ? Icons.remove_red_eye : null)),
          //hintText: hintText,
          labelText: widget.hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          )),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your ${widget.hintText}';
        }
        return null;
      },
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
    );
  }
}

// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final int maxLines;
//   final TextInputType keyboardType;
//   const CustomTextField(
//       {Key? key,
//       required this.controller,
//       required this.hintText,
//       this.maxLines = 1,
//       this.keyboardType = TextInputType.text})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//           //hintText: hintText,
//           labelText: hintText,
//           border: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.black),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.black),
//           )),
//       validator: (val) {
//         if (val == null || val.isEmpty) {
//           return 'Enter your $hintText';
//         }
//         return null;
//       },
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//     );
//   }
// }
