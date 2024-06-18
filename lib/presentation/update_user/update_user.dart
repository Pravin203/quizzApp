import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quikapp/data/user_model.dart';
import 'package:quikapp/domain/firebase_service/firebase_service.dart';
import 'package:quikapp/ui_library/app_theme.dart';
import 'package:quikapp/ui_library/custom_button.dart';
import 'package:quikapp/ui_library/custom_textfield.dart';
import 'package:quikapp/ui_library/loader.dart';

class UpdateUserDetails extends StatefulWidget {
  final UserModel userDetails;

  const UpdateUserDetails({Key? key, required this.userDetails})
      : super(key: key);

  @override
  State<UpdateUserDetails> createState() => _UpdateUserDetailsState();
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  final _firebaseCloudService = FirebaseService();

  final _formKey = GlobalKey<FormState>();
  bool isQrEnabled = false;
  bool isManualEnabled = true;
  bool isDisable = true;
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _weightNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _heightController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _profileImageUrl = '';
  bool _formSubmitted = false;

  @override
  void initState() {
    super.initState();
    _lastNameController.text = widget.userDetails.lastName ?? '';
    _firstNameController.text = widget.userDetails.firstName ?? '';
    _weightNameController.text = widget.userDetails.weight ?? '';
    _emailController.text = widget.userDetails.email ?? '';
    _heightController.text = widget.userDetails.height ?? '';
    _descriptionController.text = widget.userDetails.description ?? '';

    /// Print all initialized controller values
    print('First Name: ${_firstNameController.text}');
    print('Last Name: ${_lastNameController.text}');
    print('Company Name: ${_weightNameController.text}');
    print('Email: ${_emailController.text}');
    print('Role: ${_heightController.text}');
    print('Profile Image URL: $_profileImageUrl');
  }

  void saveEditProfileCard() async {
    try {
      final isValid = _formKey.currentState?.validate();
      User? user = FirebaseAuth.instance.currentUser;
      setState(() {
        _formSubmitted = true;
      });

      if (isValid == true) {
        Loader(context).startLoading();

        // Create a map to store updated fields
        Map<String, dynamic> updatedFields = {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'companyName': _weightNameController.text,
          'role': _heightController.text,
          'email': _emailController.text,
          'description': _descriptionController.text,
          'updatedAt': DateTime.now().toString(),
        };

        // Merge existing data with updated fields
        Map<String, dynamic> updateProfileDetails = {
          ...widget.userDetails.toJson(),
          ...updatedFields
        };

        // Update the user details on the server
        await _firebaseCloudService.updateUsersDetail(
          user!.uid.toString(),
          updateProfileDetails,
        );

        print('Updated profile details: $updateProfileDetails');

        // Display success message or navigate to another screen
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false,
            );
          });
        }
      } else {
     //   Looks like you missed something
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during form submission: $e');
      }
      // Handle error
      // Display error message or perform error handling
    } finally {
      Loader(context).stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        // This will fix the problem
        backgroundColor: AppTheme.lightBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            size: 24,
            Icons.arrow_back,
            color: AppTheme.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Update User',
          style: AppTheme.h6.copyWith(color: AppTheme.white),
        ),

      ),
      backgroundColor: AppTheme.white,
      body: Form(
        autovalidateMode: _formSubmitted
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              right: screenWidth * 0.05,
              left: screenWidth * 0.05,
              // top: screenHeight * 0.016,
              bottom: screenHeight * 0.020),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              Text(
                'Personal details',
                style: AppTheme.h7.copyWith(color: AppTheme.darkGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              CustomTextField(
                isFilled: true,
                fillColor: AppTheme.textFieldblackColor,
                controller: _lastNameController,
                hintText: 'Last name',
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Health details',
                style: AppTheme.h7.copyWith(color: AppTheme.darkGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                isFilled: true,
                fillColor: AppTheme.textFieldblackColor,
                controller: _weightNameController,
                hintText: 'Company name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 8),
              CustomTextField(
                enable: isDisable,
                isFilled: true,
                fillColor: AppTheme.textFieldblackColor,
                controller: _heightController,
                hintText: 'Role',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Email',
                style: AppTheme.h7.copyWith(color: AppTheme.darkGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                isFilled: true,
                fillColor: AppTheme.textFieldblackColor,
                controller: _emailController,
                hintText: 'Enter email address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ''; // Return error message for empty input
                  }
                  // Regular expression to match Gmail address pattern
                  const pattern =
                      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                  final regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return ''; // Return error message for invalid Gmail format
                  }
                  // You can add additional checks here if needed, such as checking for banned words, etc.
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Health Description',
                style: AppTheme.h7.copyWith(color: AppTheme.darkGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
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
              const SizedBox(height: 44),
              Button(
                text: 'Save changes',
                onPressed: saveEditProfileCard,
                variant: ButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
