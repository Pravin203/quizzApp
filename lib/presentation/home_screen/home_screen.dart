import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quikapp/data/user_model.dart';
import 'package:quikapp/domain/firebase_service/firebase_service.dart';
import 'package:quikapp/presentation/home_screen/bloc.dart';
import 'package:quikapp/presentation/home_screen/events.dart';
import 'package:quikapp/presentation/home_screen/state.dart';
import 'package:quikapp/presentation/update_user/update_user.dart';
import 'package:quikapp/ui_library/app_theme.dart';
import 'package:quikapp/ui_library/custom_button.dart';
import 'package:quikapp/ui_library/loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late UserCardDataBloc userCardBloc;
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void dispose() {
    userCardBloc.close(); // Close the bloc to free up resources
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userCardBloc = UserCardDataBloc();
    // Only call the API if the data hasn't been loaded yet
    userCardBloc.add(FetchUserData(userId!));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.lightBlue,
        title: Text('Home Screen'),
      ),
      backgroundColor: AppTheme.white,
      body: BlocProvider(
        create: (context) => userCardBloc,
        child: BlocConsumer<UserCardDataBloc, UserDataState>(
          listener: (context, state) {
            if (state is DeleteAccountLoading) {
              Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UserDeleteSuccess) {
              Loader(context).startLoading();
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );

              });
              FirebaseAuth.instance.authStateChanges().first;
              Loader(context).startLoading();
            }
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is UserDataLoaded) {
              UserModel user = state.user;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Button(
                        text: 'Update User',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateUserDetails(
                                      userDetails: user,
                                    )),
                          );
                        },
                        variant: ButtonVariant.primary,
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      Button(
                        text: 'Delete User Details',
                        onPressed: () {
                          userCardBloc.add(DeleteUserEvent());                        },
                        variant: ButtonVariant.primary,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.white),
              );
            }
          },
        ),
      ),
    );
  }
}
