import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lion_sales/reusable_widgets/app_loading_widget.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

import '../../../blocs/bloc.dart';
import '../../../blocs/validator.dart';
import '../../../reusable_widgets/app_button.dart';
import '../../../reusable_widgets/app_text_field.dart';
import '../../../utils/constant_images.dart';
import 'login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      _bloc = LoginBloc(context, this);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Body(bloc: _bloc);
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
    required LoginBloc bloc,
  }) : _bloc = bloc;

  final LoginBloc _bloc;

  @override
  Widget build(BuildContext context) {
    final double height = context.height;
    final double width = context.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ConstantColors.appBlackColor,
        body: SafeArea(child:
            KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          return StreamBuilder<bool>(
              initialData: true,
              stream: _bloc.showIcon,
              builder: (context, snapshot) {
                return Stack(
                  // fit: StackFit.passthrough,
                  // alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    if (!isKeyboardVisible)
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Image.asset(ConstantImages.TOP_LEFT_CURVE,
                              height: height / 11)),
                    if (!isKeyboardVisible)
                      if (snapshot.data!)
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset(
                                ConstantImages.BOTTOM_RIGHT_CURVE,
                                height: height / 8)),
                    SizedBox(
                      height: height,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Form(
                            key: _bloc.formKey,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: height / 9),
                                Image.asset(ConstantImages.APP_LOGO,
                                    width: width / 2),
                                SizedBox(height: height / 12),
                                Text(ConstantStrings.LOGIN,
                                    style: poppinsTextStyle(
                                        textColor: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(height: height / 20),
                                MyTextField(
                                     onFieldSubmitted: (v){},
                                  controller: _bloc.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  labelText: ConstantStrings.EMAIL,
                                  hintText: ConstantStrings.EMAIL,
                                  validate: (value) {
                                    return emailValidate(value);
                                  },
                                ),
                                SizedBox(height: height / 25),
                                StreamBuilder<bool>(
                                    stream: _bloc.showPassword,
                                    initialData: true,
                                    builder: (context, snapshot) {
                                      return MyTextField(
                                           onFieldSubmitted: (v){},
                                        suffix: true,
                                        controller: _bloc.passwordController,
                                        labelText: ConstantStrings.PASSWORD,
                                        hintText: ConstantStrings.PASSWORD,
                                        isPassword: snapshot.data ?? true,
                                        validate: (value) {
                                          return passwordValidate(value);
                                        },
                                        action: TextInputAction.done,
                                        onEyeTap: () {
                                          _bloc.changeVisibility();
                                        },
                                      );
                                    }),
                                SizedBox(height: height / 12),
                                StreamBuilder<ApiResponse>(
                                    stream: _bloc.loginSubject,
                                    builder: (context, snapshot) {
                                      var isLoading = snapshot.hasData &&
                                          snapshot.data?.status ==
                                              Status.loading;
                                      return isLoading
                                          ? const AppLoadingWidget()
                                          : AppButton(
                                              height: height,
                                              width: width,
                                              text: ConstantStrings.LOGIN,
                                              onTap:
                                                  // isLoading
                                                  //     ?
                                                  () {
                                                _bloc.onLogin();
                                              }
                                              // : () {},
                                              );
                                    }),
                                SizedBox(height: height / 50),
                                // Center(
                                //   child: GestureDetector(
                                //     onTap: () =>
                                //         _bloc.navigateToForgotPassword(),
                                //     child: Text(
                                //       ConstantStrings.FORGOT_YOUR_PASSWORD,
                                //       style: poppinsTextStyle(
                                //           fontWeight: FontWeight.w600,
                                //           textColor:
                                //               ConstantColors.appPrimaryColor),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: height / 50),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Text(ConstantStrings.CREATE_NEW_ACCOUNT,
                                //         style: poppinsTextStyle(
                                //             textColor: Colors.white)),
                                //     SizedBox(width: width / 50),
                                //     GestureDetector(
                                //       onTap: () => _bloc.navigateToRegister(),
                                //       child: Text(ConstantStrings.SIGN_UP,
                                //           style: poppinsTextStyle(
                                //               textColor: ConstantColors
                                //                   .appPrimaryColor)),
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        })),
      ),
    );
  }
}
