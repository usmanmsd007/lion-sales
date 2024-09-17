import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:lion_sales/blocs/bloc.dart';
import 'package:lion_sales/reusable_widgets/app_button.dart';
import 'package:lion_sales/reusable_widgets/app_loading_widget.dart';
import 'package:lion_sales/utils/constant_images.dart';
import 'package:lion_sales/utils/extensions.dart';

import '../../../blocs/validator.dart';
import '../../../reusable_widgets/app_text_field.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/utils.dart';
import 'forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotPasswordBloc _bloc;

  @override
  void didChangeDependencies() {
    if (mounted) {
      _bloc = ForgotPasswordBloc(context, this);
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: ConstantColors.appBlackColor,
          body: Body(bloc: _bloc)),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
    required ForgotPasswordBloc bloc,
  }) : _bloc = bloc;

  final ForgotPasswordBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          height: context.height / 1.65,
          width: context.width / 1.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: const Color(0xFFFFFFFF).withOpacity(.25),
                  blurRadius: 4.0,
                  offset: const Offset(-12, -12))
            ],
            color: const Color(0xFF2E2B23).withOpacity(.8),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width / 20),
              child: StreamBuilder<int?>(
                  stream: _bloc.isMailSubmitted,
                  initialData: 1,
                  builder: (context, snapShot) {
                    int screenNo = snapShot.data ?? 1;
                    return screenNo == 1
                        ? DialogBoxEmailFieldWidget(
                            bloc: _bloc,
                          )
                        : screenNo == 2
                            ? DialogBoxOtpWidget(bloc: _bloc)
                            : screenNo == 3
                                ? DialogBoxForgetPasswordWidget(bloc: _bloc)
                                : DialogBoxSuccessfulWidget(
                                    bloc: _bloc,
                                  );
                  })
              // DialogBoxEmailFieldWidget(height: height, bloc: _bloc, width: width),
              ),
        ),
      ),
    );
  }
}

class DialogBoxSuccessfulWidget extends StatelessWidget {
  const DialogBoxSuccessfulWidget({
    super.key,
    required this.bloc,
  });

  final ForgotPasswordBloc bloc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: context.height / 10),
          Image.asset(ConstantIcons.IC_LOCK, height: context.height / 12),
          SizedBox(height: context.height / 50),
          Text(
            ConstantStrings.SUCCESSFULLY_RECOVER_PASSWORD,
            textAlign: TextAlign.center,
            style: poppinsTextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 22,
                textColor: Colors.white),
          ),
          SizedBox(height: context.height / 30),
          Text(
            ConstantStrings.CORRECT_PASSWORD,
            style: poppinsTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                textColor: ConstantColors.appPrimaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height / 20),
          StreamBuilder<ApiResponse>(
              stream: bloc.forgetPasswordSubject,
              builder: (context, snapshot) {
                var isLoading =
                    snapshot.hasData && snapshot.data?.status == Status.loading;
                return isLoading
                    ? const AppLoadingWidget()
                    : SizedBox(
                        height: context.height / 20,
                        width: context.width / 2,
                        child: AppButton(
                            height: context.height,
                            width: context.width,
                            onTap: () {
                              bloc.navigateToLogin();
                            },
                            text: ConstantStrings.LOGIN),
                      );
              }),
        ],
      ),
    );
  }
}

class DialogBoxEmailFieldWidget extends StatelessWidget {
  const DialogBoxEmailFieldWidget({
    super.key,
    required this.bloc,
  });

  final ForgotPasswordBloc bloc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: context.height / 10),
          Text(
            ConstantStrings.FORGET_PASSWORD,
            style: poppinsTextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 26,
                textColor: Colors.white),
          ),
          SizedBox(height: context.height / 30),
          Text(
            ConstantStrings.INCORRECT_PASSWORD,
            style: poppinsTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                textColor: ConstantColors.appPrimaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height / 10),
          Form(
            key: bloc.emailFormKey,
            child: MyTextField(
              onFieldSubmitted: (v){},
                controller: bloc.emailController,
                hintText: ConstantStrings.EMAIL,
                labelText: ConstantStrings.EMAIL,
                action: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                validate: (value) => emailValidate(value)),
          ),
          SizedBox(height: context.height / 20),
          StreamBuilder<ApiResponse>(
              stream: bloc.forgetPasswordSubject,
              builder: (context, snapshot) {
                var isLoading =
                    snapshot.hasData && snapshot.data?.status == Status.loading;
                return isLoading
                    ? const AppLoadingWidget()
                    : SizedBox(
                        height: context.height / 20,
                        width: context.width / 2,
                        child: AppButton(
                            height: context.height,
                            width: context.width,
                            onTap: () {
                              bloc.onForgetPassword();
                            },
                            text: ConstantStrings.SUBMIT),
                      );
              }),
          SizedBox(
            height: context.height / 50,
          ),
          SizedBox(
            height: context.height / 20,
            width: context.width / 2,
            child: AppButton(
                height: context.height,
                width: context.width,
                onTap: () {
                  bloc.navigateToLogin();
                },
                text: ConstantStrings.CLOSE),
          ),
          SizedBox(
            height: context.height / 30,
          ),
        ],
      ),
    );
  }
}

class DialogBoxForgetPasswordWidget extends StatelessWidget {
  const DialogBoxForgetPasswordWidget({
    super.key,
    required this.bloc,
  });
  final ForgotPasswordBloc bloc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: context.height / 20),
          Text(
            ConstantStrings.CHANGE_PASSWORD,
            style: poppinsTextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 26,
                textColor: Colors.white),
          ),
          SizedBox(height: context.height / 30),
          Text(
            ConstantStrings.ENTER_NEW_PASSWORD,
            style: poppinsTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                textColor: ConstantColors.appPrimaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height / 15),
          Form(
            key: bloc.newPasswordFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<bool>(
                      stream: bloc.showPassword,
                      initialData: false,
                      builder: (context, snapshot) {
                        return MyTextField(
                          onFieldSubmitted: (v){},
                            controller: bloc.passwordController,
                            hintText: ConstantStrings.NEW_PASSWORD,
                            onEyeTap: () {
                              bloc.changeVisibility();
                            },
                            labelText: ConstantStrings.NEW_PASSWORD,
                            isPassword: snapshot.data!,
                            suffix: true,
                            keyboardType: TextInputType.visiblePassword,
                            validate: (value) => passwordValidate(value));
                      }),
                  SizedBox(
                    height: context.height / 25,
                  ),
                  StreamBuilder<bool>(
                      stream: bloc.showPassword,
                      initialData: false,
                      builder: (context, snapshot) {
                        return MyTextField(
                          onFieldSubmitted: (v){},
                            controller: bloc.confirmPasswordController,
                            hintText: ConstantStrings.CONFIRM_PASSWORD,
                            onEyeTap: () {
                              bloc.changeVisibility();
                            },
                            labelText: ConstantStrings.CONFIRM_PASSWORD,
                            isPassword: snapshot.data!,
                            suffix: true,
                            action: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            validate: (val) {
                              if (val!.isEmpty) {
                                return ConstantStrings.CONFIRM_PASSWORD_MISSING;
                              }
                              if (val != bloc.passwordController.text) {
                                return ConstantStrings.PASSWORD_DONOT_MATCH;
                              }
                              return null;
                            });
                      }),
                ],
              ),
            ),
          ),
          SizedBox(height: context.height / 20),
          StreamBuilder<ApiResponse>(
              stream: bloc.changePasswordSubject,
              builder: (context, snapshot) {
                var isLoading =
                    snapshot.hasData && snapshot.data?.status == Status.loading;
                return isLoading
                    ? const AppLoadingWidget()
                    : SizedBox(
                        height: context.height / 20,
                        width: context.width / 2,
                        child: AppButton(
                            height: context.height,
                            width: context.width,
                            onTap: () {
                              bloc.onChangePassword();
                            },
                            text: ConstantStrings.SUBMIT),
                      );
              }),
          SizedBox(
            height: context.height / 50,
          ),
          SizedBox(
            height: context.height / 20,
            width: context.width / 2,
            child: AppButton(
                height: context.height,
                width: context.width,
                onTap: () {
                  bloc.navigateToLogin();
                },
                text: ConstantStrings.CLOSE),
          ),
          SizedBox(
            height: context.height / 30,
          ),
        ],
      ),
    );
  }
}

class DialogBoxOtpWidget extends StatelessWidget {
  const DialogBoxOtpWidget({
    super.key,
    required this.bloc,
  });

  final ForgotPasswordBloc bloc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: context.height / 20),
          Image.asset(ConstantIcons.IC_LOCK, height: context.height / 12),
          SizedBox(height: context.height / 50),
          Text(
            ConstantStrings.VERIFY_EMAIL,
            textAlign: TextAlign.center,
            style: poppinsTextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 22,
                textColor: Colors.white),
          ),
          SizedBox(height: context.height / 30),
          Text(
            ConstantStrings.ENTER_OTP,
            style: poppinsTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                textColor: ConstantColors.appPrimaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height / 20),
          Form(
            key: bloc.otpFormKey,
            child: PinCodeTextField(
              appContext: context,
              validator: (v) {
                if (v!.length < 6) {
                  return ConstantStrings.PROVIDE_FULL_OTP;
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.disabled,
              length: 6,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                activeColor: ConstantColors.appPrimaryColor,
                selectedColor: ConstantColors.appPrimaryColor,
                inactiveColor: ConstantColors.appPrimaryColor,
                disabledColor: ConstantColors.appPrimaryColor,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 30,
                activeFillColor: Colors.white,
              ),
              textStyle: poppinsTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  textColor: ConstantColors.appPrimaryColor),
              controller: bloc.otpController,
              onCompleted: (v) {
                FocusManager.instance.primaryFocus!.unfocus();
              },
            ),
          ),
          SizedBox(height: context.height / 20),
          StreamBuilder<ApiResponse>(
              stream: bloc.verifyOtpSubject,
              builder: (context, snapshot) {
                var isLoading =
                    snapshot.hasData && snapshot.data?.status == Status.loading;
                return isLoading
                    ? const AppLoadingWidget()
                    : SizedBox(
                        height: context.height / 20,
                        width: context.width / 2,
                        child: AppButton(
                            height: context.height,
                            width: context.width,
                            onTap: () {
                              bloc.verifyOtp();
                            },
                            text: ConstantStrings.VERIFY_EMAIL),
                      );
              }),
          SizedBox(
            height: context.height / 50,
          ),
          SizedBox(
            height: context.height / 20,
            width: context.width / 2,
            child: AppButton(
                height: context.height,
                width: context.width,
                onTap: () {
                  bloc.navigateToLogin();
                },
                text: ConstantStrings.CLOSE),
          ),
          SizedBox(
            height: context.height / 10,
          ),
        ],
      ),
    );
  }
}
