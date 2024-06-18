import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quikapp/data/user_model.dart';
import 'package:quikapp/domain/firebase_service/firebase_service.dart';
import 'package:quikapp/ui_library/app_theme.dart';
import 'package:quikapp/ui_library/custom_button.dart';
import 'package:quikapp/ui_library/custom_textfield.dart';
import 'package:quikapp/ui_library/loader.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _emailController = TextEditingController();
  final _hieghtController = TextEditingController();
  final _descrptionController = TextEditingController();
  final _firebaseCloudService = FirebaseService();
  bool _formSubmitted = false;

  @override
  void dispose() {
    _lastNameController.dispose();
    _weightController.dispose();
    _emailController.dispose();
    _hieghtController.dispose();
    super.dispose();
  }

  void _genarateCardMethod() async {
    try {
      final isValid = _formKey.currentState?.validate();
      setState(() {
        _formSubmitted = true;
      });

      if (isValid == true) {
        final FirebaseAuth auth = FirebaseAuth.instance;
        auth.currentUser?.reload();
        String? phoneNumber = auth.currentUser?.phoneNumber;
        String? countryCode;
        String? mobileNumber;

        if (phoneNumber != null && phoneNumber.isNotEmpty) {
          // Remove any whitespace characters from the phone number
          phoneNumber = phoneNumber.replaceAll(' ', '');
          // Check if the phone number starts with a '+' sign
          if (phoneNumber.startsWith('+')) {
            // If it starts with '+', extract the country code and mobile number
            countryCode = phoneNumber.substring(
                0, 3); // Assuming the country code length is 3 characters
            mobileNumber = phoneNumber.substring(3);
          } else {
            // If it doesn't start with '+', assume the entire number is the mobile number
            mobileNumber = phoneNumber;
          }
        }

        Loader(context).startLoading();

        UserModel userDetails = UserModel(
            id: auth.currentUser!.uid,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            weight: _weightController.text,
            height: _hieghtController.text,
            email: _emailController.text,
            phoneNumber: mobileNumber,
            createdAt: DateTime.now(),
            description: _descrptionController.text);
        await _firebaseCloudService.createUser(userDetails);
        if (mounted) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/dashboard', (route) => false);
          });
        }
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 1000),
            content:
            Text(' Looks like you missed something.\nAll fields must be filled.'),
          ),
        );

      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during signup: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Form(
        autovalidateMode: _formSubmitted
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/Illustration.png'),
                Center(child: SvgPicture.asset('assets/Logo.svg')),
                const SizedBox(
                  height: 35,
                ),
                Text(
                  'Personal details',
                  style: AppTheme.h7.copyWith(color: AppTheme.darkGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  textCapitalization: TextCapitalization.words,
                  isFilled: true,
                  fillColor: AppTheme.textFieldblackColor,
                  controller: _firstNameController,
                  hintText: 'First name ',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  textCapitalization: TextCapitalization.words,
                  isFilled: true,
                  fillColor: AppTheme.textFieldblackColor,
                  controller: _lastNameController,
                  hintText: 'Last name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Health Details',
                  style: AppTheme.h7.copyWith(color: AppTheme.darkGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  keyboard: TextInputType.number,
                  isFilled: true,
                  fillColor: AppTheme.textFieldblackColor,
                  controller: _weightController,
                  hintText: 'Weight',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null; // Return null if the input is valid
                  },
                  // Add validation if needed
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  isFilled: true,
                  keyboard: TextInputType.number,
                  fillColor: AppTheme.textFieldblackColor,
                  controller: _hieghtController,
                  hintText: 'Height',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null; // Return null if the input is valid
                  },
                  // Add validation if needed
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Email',
                  style: AppTheme.h7.copyWith(color: AppTheme.darkGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  isFilled: true,
                  fillColor: AppTheme.textFieldblackColor,
                  controller: _emailController,
                  hintText: 'Enter email address',
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Health Description',
                  style: AppTheme.h7.copyWith(color: AppTheme.darkGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _descrptionController,
                  style: AppTheme.h6.copyWith(color: AppTheme.borderColor),
                  decoration: InputDecoration(
                    hintText: 'Add any other details',
                    hintStyle: const TextStyle(
                      color: AppTheme.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding:
                        const EdgeInsets.fromLTRB(10, 18.5, 5.0, 1.0),
                    labelStyle: const TextStyle(
                      color: AppTheme.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppTheme.borderColor,
                        width: 1,
                      ),
                      gapPadding: 4,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppTheme.borderColor,
                        width: 2,
                      ),
                      gapPadding: 4,
                    ),
                    errorStyle: const TextStyle(height: 0, color: AppTheme.white
                        // Hide the error text
                        ),
                    prefixIconColor: Colors.yellow,
                    filled: true,
                    fillColor: AppTheme.textFieldblackColor,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                ),
                const SizedBox(
                  height: 24,
                ),
                const SizedBox(
                  height: 60,
                ),
                Button(
                  text: 'Register',
                  onPressed: _genarateCardMethod,
                  variant: ButtonVariant.primary,
                ),
                const SizedBox(
                  height: 11,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
