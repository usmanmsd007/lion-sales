import 'package:flutter/material.dart';
import 'package:lion_sales/blocs/bloc.dart';
import 'package:lion_sales/reusable_widgets/app_text_field.dart';
import 'package:lion_sales/screens/home/bottom_nav_bar/bottom_nav_screen.dart';
import 'package:lion_sales/screens/home/resetPassword/reset_password_bloc.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

import '../../../reusable_widgets/appBar/custom_appbar.dart';
import '../../../reusable_widgets/app_loading_widget.dart';
import '../../../utils/constant_strings.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordBloc _bloc;

  @override
  void didChangeDependencies() {
    if (mounted) {
      _bloc = ResetPasswordBloc(context, this)..setInitialData();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          showBackButton: true,
          onTap: () {
            Navigator.of(context).pop();
          },
          title: ConstantStrings.RESET_PASSWORD,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: context.height / 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width / 40),
                child: Text(
                  "Provide the following details \n to change your password",
                  overflow: TextOverflow.clip,
                  style: poppinsTextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      textColor: ConstantColors.appPrimaryColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.height / 50,
          ),
          Form(
            key: _bloc.formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width / 20),
              child: Column(
                children: [
                  StreamBuilder<bool>(
                      stream: _bloc.showPassword,
                      initialData: false,
                      builder: (context, snapshot) {
                        return MyTextField(
                          textColor: false,   onFieldSubmitted: (v){},
                          validate: (v) => _bloc.validateOldPassword(v),
                          labelText: "Old Password",
                          controller: _bloc.oldPasswordController,
                          hintText: "Old Password",
                          isPassword: snapshot.data!,
                          suffix: true,
                          onEyeTap: () {
                            _bloc.hidePassword();
                          },
                        );
                      }),
                  SizedBox(
                    height: context.height / 50,
                  ),
                  StreamBuilder<bool>(
                      initialData: false,
                      stream: _bloc.showPasswordTwo,
                      builder: (context, snapshotTwo) {
                        return MyTextField(
                          textColor: false,   onFieldSubmitted: (v){},
                          validate: (v) => _bloc.validatePassword(v),
                          labelText: "New Password",
                          controller: _bloc.passwordController,
                          hintText: "New Password",
                          isPassword: snapshotTwo.data!,
                          suffix: true,
                          onEyeTap: () {
                            _bloc.hidePasswordTwo();
                          },
                        );
                      }),
                  SizedBox(
                    height: context.height / 50,
                  ),
                  StreamBuilder<bool>(
                      stream: _bloc.showPasswordThree,
                      initialData: false,
                      builder: (context, snapshotThree) {
                        return MyTextField(   onFieldSubmitted: (v){},
                          textColor: false,
                          validate: (v) => _bloc.validateConfirmPassword(v),
                          labelText: "Confirm Password",
                          controller: _bloc.confirmPasswordController,
                          hintText: "Confirm Password",
                          suffix: true,
                          onEyeTap: () {
                            _bloc.hidePasswordThree();
                          },
                          isPassword: snapshotThree.data!,
                        );
                      }),
                  SizedBox(
                    height: context.height / 50,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: context.height / 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<ApiResponse>(
                  stream: _bloc.resetPasswordSubject,
                  builder: (context, snapshot) {
                    bool isLoadingThree = snapshot.hasData &&
                        snapshot.data!.status == Status.loading;
                    return isLoadingThree
                        ? const Center(child: AppLoadingWidget())
                        : GestureDetector(
                            onTap: () {
                              _bloc.onChangePassword(
                                  () => showDialogMethod(context));
                            },
                            child: Container(
                              height: context.height / 16,
                              width: context.width / 2,
                              decoration: BoxDecoration(
                                  color: ConstantColors.appPrimaryColor,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Text(
                                  "Update",
                                  style: poppinsTextStyle(
                                      textColor: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          );
                  }),
            ],
          )
        ],
      ),
    ));
  }

  Future<dynamic> showDialogMethod(BuildContext context) {
    return showDialog(
        context: context,
        builder: (c) => StreamBuilder<ApiResponse>(
            stream: _bloc.logoutSubject,
            builder: (context, snapshot) {
              bool isLoading =
                  snapshot.hasData && snapshot.data!.status == Status.loading;
              return Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    actionsPadding: EdgeInsets.symmetric(
                        horizontal: context.width / 20,
                        vertical: context.height / 40),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: context.width / 20,
                        vertical: context.height / 40),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ConstantStrings.LOGOUT,
                          style: poppinsTextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              textColor: ConstantColors.appPrimaryColor),
                        ),
                      ],
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(ConstantStrings.SURE_LOGOUT,
                            style: poppinsTextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                textColor: ConstantColors.appBlackColor)),
                      ],
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      GestureDetector(
                        onTap: isLoading
                            ? () {}
                            : () {
                                // int count = 0;
                                Navigator.of(context, rootNavigator: true)
                                    .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (c) => BottomNavScreen(
                                                  index: 4,
                                                )),
                                        (route) => false);
                              },
                        child: Text(ConstantStrings.NO,
                            style: poppinsTextStyle(
                                fontSize: 15,
                                textColor: ConstantColors.appBlackColor)),
                      ),
                      SizedBox(
                        width: context.width / 45,
                      ),
                      GestureDetector(
                        onTap: isLoading
                            ? () {}
                            : () {
                                _bloc.logOut();
                              },
                        child: Text(ConstantStrings.YES,
                            style: poppinsTextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                textColor: ConstantColors.appPrimaryColor)),
                      ),
                    ],
                  ),
                  if (isLoading)
                    const Positioned(
                        child: Center(
                      child: AppLoadingWidget(),
                    ))
                ],
              );
            }));
  }
}
