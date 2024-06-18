import 'package:country_code_picker/country_code_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:quikapp/domain/firebase_auth_service/auth_service.dart';
import 'package:quikapp/domain/firebase_service/firebase_service.dart';
import 'package:quikapp/presentation/login_screen/bloc/login_bloc.dart';
import 'package:quikapp/presentation/login_screen/bloc/login_events.dart';
import 'package:quikapp/presentation/login_screen/bloc/login_state.dart';
import 'package:quikapp/presentation/registartion_screen/regisatrion_screen.dart';
import 'package:quikapp/ui_library/app_theme.dart';
import 'package:quikapp/ui_library/custom_button.dart';
import 'package:quikapp/ui_library/custom_textfield.dart';
import 'package:quikapp/ui_library/loader.dart';

class LoginScreen extends StatefulWidget {
  final int salectedIndex;

  // final userUid;
  const LoginScreen({
    Key? key,
    required this.salectedIndex,
  }) : super(key: key);

  @override
  State createState() => _LoginScreenState(salectedIndex);
}

class _LoginScreenState extends State<LoginScreen> {
  late int _currentIndex;

  _LoginScreenState(int salectedIndex) {
    _currentIndex = salectedIndex;
  }

  final List<String> _appBarTitles = [
    'Login Screen',
    'Otp Screen',
    ''
  ];
  String _selectedCountryCode = "+91";
  final mobileInputController = TextEditingController();
  final _authService = FirebaseAuthService();
  final _firebaseService = FirebaseService();
  late final LoginScreenBloc _loginBloc;
  String verificationCode = '';
  String errorMessage = '';
  String code = '';
  bool enableResend = false;
  int numberOfFields = 7;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Analytics.setCurrentScreen('LoginScreen');

    _loginBloc = LoginScreenBloc(
      FirebaseAuthService(),
    );
  }

  Future<void> handleLogin(BuildContext context) async {
    final mobile = mobileInputController.text.trim();
    final countryCode = _selectedCountryCode;
    print(' mobile number and contry code {$countryCode$mobile,}');
    if (mobile.isEmpty || mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: mobile.isEmpty
              ? Text('Please enter mobile number')
              : Text('Mobile number must be 10 digits'),
        ),
      );
    } else {
      Loader(context).startLoading();
      final parsedNumber = PhoneNumber.parse('$countryCode$mobile');
      if (parsedNumber.isValid()) {
        // The phone number is valid, start loader
        // Perform the OTP request

        _loginBloc.add(RequestOTPEvent(
          mobileNumber: '$countryCode$mobile',
          onRequestSuccess: (verificationId, resendToken) async {
            await onRequestSuccessCallback(
                context, verificationId, resendToken);
          },
          onRequestFailure: (error) {
            otpRequestFailure(error, context);
          },
        ));
      } else {
        // The phone number is not valid
        if (kDebugMode) {
          print('Phone number is not valid');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid mobile number'),
          ),
        );
      }
    }
  }

  String verificationId = ''; // Add this line to store verificationId
  int? resendToken; // Define resendToken as a class variable

  // Other existing code...

  Future<void> onRequestSuccessCallback(
      BuildContext context, String verificationId, int? resendToken) async {
    setState(() {
      _currentIndex = 1;
      this.verificationId = verificationId;
      this.resendToken = resendToken; // Store the resendToken
      print('print resend token url in console ${resendToken}');
      // Store the verificationId
    });
    Loader(context).stopLoading();
  }

  otpRequestFailure(error, BuildContext context) => {
        Text("$error"),
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message!),
          ),
        )
      };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginScreenBloc(FirebaseAuthService()),
      child: Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              size: 24,
              Icons.arrow_back_ios,
              color: AppTheme.white,
            ),
            onPressed: () {
              if (_currentIndex == 0) {

              } else {
                if (_currentIndex == 2) {


                } else {
                  setState(() {
                    _currentIndex--;
                  });
                }
              }
            },
          ),
          centerTitle: true,
          title: Text(
            _appBarTitles[_currentIndex],
            style: AppTheme.h4.copyWith(color: AppTheme.lightBlue),
          ),
        ),
        body: BlocConsumer<LoginScreenBloc, LoginScreenState>(
          listener: (context, state) {
            if (state is RequestOTPSuccess) {
              const CircularProgressIndicator();
            } else if (state is RequestOTPFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('RequestOTPFailure'),
                ),
              );
            } else if (state is VerifyOTPFailure) {
              print('VerifyOTPFailure error ${state.error}');
            }
          },
          builder: (context, state) {
            if (state is LoginLoading || state is RequestOTPSuccess) {
              const CircularProgressIndicator();
            }
            if (state is LoginScreenInitial) {
              return _buildContent();
            } else {
              // Return a placeholder widget if none of the conditions match
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentIndex) {
      case 0:
        return Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/Illustration.png'),
              const SizedBox(
                height: 32,
              ),
              Text(
                'Welcome to Health Track',
                style: AppTheme.h2.copyWith(color: AppTheme.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Take your next step towards healthier\nand more active life.',
                style: AppTheme.h7.copyWith(color: AppTheme.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.textFieldblackColor,
                          border: Border.all(
                            color: AppTheme.borderColor,
                            // Specify border color here
                            width: 1, // Specify border width here
                          ),
                          borderRadius: BorderRadius.circular(
                              14), // Specify border radius here
                        ),
                        child: CountryCodePicker(
                          // dialogBackgroundColor: Colors.black,
                          boxDecoration: BoxDecoration(boxShadow: []),
                          padding: EdgeInsets.zero,
                          flagWidth: 27,
                          // Customize the width of the flag
                          textStyle: AppTheme.h6.copyWith(
                            color: AppTheme.borderColor,
                          ),
                          backgroundColor: AppTheme.black,
                          onChanged: (phone) {
                            setState(() {
                              _selectedCountryCode = phone.dialCode ?? "+91";
                            });
                            print(
                                "Selected country code: $_selectedCountryCode");
                          },
                          // Set initial selection to India ('IN')
                          initialSelection: '+91',
                          favorite: ['+91'],
                          // Add India to favorites
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        )),
                    const SizedBox(width: 8),
                    // Add some space between the fields
                    Expanded(
                      child: CustomTextField(
                        keyboard: TextInputType.number,
                        hintText: 'Enter mobile number ',
                        isFilled: true,
                        fillColor: AppTheme.textFieldblackColor,
                        controller:
                            mobileInputController, // Change the fill color here
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: Button(
                  text: 'Send verification code',
                  onPressed: () {

                    handleLogin(context);
                  },
                  variant: ButtonVariant.primary,
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        );
      case 1:
        return Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 32,
              ),
              Center(child: SvgPicture.asset('assets/Logo.svg')),
              const SizedBox(height: 15),

              Text(
                'Verify it’s you!',
                style: AppTheme.h2.copyWith(color: AppTheme.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                'Sent On Your Mobile Number',
                style: AppTheme.h7.copyWith(color: AppTheme.darkGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: CustomTextField(
                    keyboard: TextInputType.number,
                    hintText: 'Enter code',
                    maxLength: 6,
                    onChanged: (value) {
                      setState(() {
                        errorMessage = '';
                        code = value.trim();
                      });
                    },

                    isFilled: true,
                    fillColor: AppTheme.textFieldblackColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Button(
                  text: 'Verify',
                  onPressed: () async {
                    // Analytics.setUserId();
                    if (code.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 1000),
                          content: Text('Please enter the verification code'),
                        ),
                      );
                      return;
                    }
                    // Check if the OTP code length is not equal to 6
                    if (code.length != 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 1000),
                          content:
                              Text('Please enter a 6-digit verification code'),
                        ),
                      );
                      return;
                    }
                    try {
                      Loader(context).startLoading();
                      FirebaseAuth auth = FirebaseAuth.instance;
                      String? userId =
                          auth.currentUser?.uid; // Get the current user ID
                      // Loader(context).startLoading();
                      await _authService.verifyOTP(verificationId, code);

                      // Handle verification success
                      FirebaseAuth.instance
                          .authStateChanges()
                          .listen((user) async {
                        if (user != null) {
                          bool userExists = await _firebaseService
                              .checkIfUserExistsInDatabase(user.uid);
                          if (userExists) {
                            ('login click uid check ${user.uid}');
                            if (mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/dashboard', (route) => false);
                            }
                          } else {
                            if (mounted) {
                              Navigator.pushReplacementNamed(
                                  context, '/registrationScreen');
                            }
                          }
                        }
                      });
                      // Loader(context).stopLoading();
                    } catch (e) {
                      // Handle verification failure
                      Loader(context)
                          .stopLoading(); // Stop loading if verification fails
                      setState(() {
                        if (e is FirebaseAuthException &&
                            e.code == 'invalid-verification-code') {
                          errorMessage =
                              'Invalid verification code. Please try again.';
                        } else if (e is FirebaseAuthException &&
                            e.code == 'too-many-requests') {
                          errorMessage =
                              'Too many attempts. Please try again later.';
                        } else {
                          errorMessage = 'An error occurred. Please try again.';
                        }
                      });
                    }
                    // setState(() {
                    //   _currentIndex = 2;
                    // });
                  },
                  variant: ButtonVariant.primary,
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        );

      default:
        return Container(); // Handle other cases
    }
  }
}
