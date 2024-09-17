import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lion_sales/blocs/bloc.dart';
import 'package:lion_sales/reusable_widgets/app_button.dart';
import 'package:lion_sales/utils/constant_images.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

import '../../../blocs/validator.dart';
import '../../../reusable_widgets/app_loading_widget.dart';
import '../../../reusable_widgets/app_text_field.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/constant_strings.dart';
import 'register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterBloc _bloc;

  @override
  void didChangeDependencies() {
    if (mounted) {
      _bloc = RegisterBloc(context, this);
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
    // final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;
    return BodyWidget(bloc: _bloc);
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    super.key,
    required RegisterBloc bloc,
  }) : _bloc = bloc;

  final RegisterBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ConstantColors.appBlackColor,
        body: SafeArea(
          child:
              KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
            return StreamBuilder<bool>(
                stream: _bloc.showIcon,
                initialData: true,
                builder: (context, snapshot) {
                  return Stack(
                    fit: StackFit.passthrough,
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      if (!isKeyboardVisible)
                        if (snapshot.data!)
                          Positioned(
                              // bottom: 0,
                              // right: 0,
                              child: Image.asset(
                                  ConstantImages.BOTTOM_RIGHT_CURVE,
                                  height: context.height / 8)),
                      SizedBox(
                        height: context.height,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.width / 20),
                          child: Form(
                            key: _bloc.formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                // shrinkWrap: false,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: context.height / 15),
                                  Text(
                                    ConstantStrings.REGISTER,
                                    style: poppinsTextStyle(
                                        fontWeight: FontWeight.w500,
                                        textColor: Colors.white,
                                        fontSize: 36),
                                  ),
                                  SizedBox(height: context.height / 12),
                                  MyTextField(
                                       onFieldSubmitted: (v){},
                                    controller: _bloc.firstNameController,
                                    labelText: ConstantStrings.FIRST_NAME,
                                    hintText: ConstantStrings.FIRST_NAME,
                                    validate: (value) {
                                      return firstNameValidate(value!);
                                    },
                                    onEyeTap: () {},
                                  ),
                                  SizedBox(height: context.height / 25),
                                  MyTextField(
                                       onFieldSubmitted: (v){},
                                    controller: _bloc.lastNameController,
                                    labelText: ConstantStrings.LAST_NAME,
                                    hintText: ConstantStrings.LAST_NAME,
                                    validate: (value) {
                                      return lastNameValidate(value);
                                    },
                                    onEyeTap: () {},
                                  ),
                                  SizedBox(height: context.height / 25),
                                  MyTextField(
                                       onFieldSubmitted: (v){},
                                    controller: _bloc.emailController,
                                    labelText: ConstantStrings.EMAIL,
                                    keyboardType: TextInputType.emailAddress,
                                    hintText: ConstantStrings.EMAIL,
                                    validate: (value) {
                                      return emailValidate(value);
                                    },
                                    onEyeTap: () {},
                                  ),
                                  SizedBox(height: context.height / 25),
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
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          action: TextInputAction.done,
                                          onEyeTap: () {
                                            _bloc.changeVisibility();
                                          },
                                        );
                                      }),
                                  SizedBox(height: context.height / 15),
                                  StreamBuilder<ApiResponse>(
                                      stream: _bloc.registerSubject,
                                      builder: (context, snapshot) {
                                        var isLoading = snapshot.hasData &&
                                            snapshot.data?.status ==
                                                Status.loading;
                                        return isLoading
                                            ? const AppLoadingWidget()
                                            : AppButton(
                                                height: context.height,
                                                width: context.width,
                                                text: ConstantStrings
                                                    .REGISTER_NOW,
                                                onTap: isLoading
                                                    ? () {}
                                                    : () {
                                                        _bloc.registerUser();
                                                      });
                                        // : CircularProgressIndicator();
                                      }),
                                  SizedBox(height: context.height / 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(ConstantStrings.ALREADY_REGISTER,
                                          style: poppinsTextStyle(
                                              textColor: Colors.white)),
                                      SizedBox(width: context.width / 50),
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Text(ConstantStrings.LOGIN,
                                            style: poppinsTextStyle(
                                                textColor: ConstantColors
                                                    .appPrimaryColor)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                });
          }),
        ),
      ),
    );
  }
}
