import 'package:flutter/material.dart';
import 'package:quikapp/ui_library/app_theme.dart';

class Loader {
  late BuildContext context;

  Loader(this.context);

  // This is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          // Can change this to your preferred color
          children: <Widget>[
            Center(
              child: SizedBox(
                  width: 30.0, // Width of the SizedBox
                  height: 30.0, // Height
                  child: CircularProgressIndicator(
                    backgroundColor: AppTheme.lightBlue,
                    color: AppTheme.white,
                  )),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  Future<void> showError(Object? error) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: AppTheme.lightBlue,
        content: Text(handleError(error)),
      ),
    );
  }

  // Define the handleError method to convert errors into user-friendly messages
  String handleError(Object? error) {
    // You can customize this to handle different types of errors
    if (error is Exception) {
      return error.toString();
    } else {
      return 'An unknown error occurred';
    }
  }
}
