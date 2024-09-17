import 'package:flutter/material.dart';
import 'package:lion_sales/reusable_widgets/app_loading_widget.dart';
import 'package:lion_sales/screens/home/resetPassword/reset_password_screen.dart';
import 'package:lion_sales/screens/home/settings/setting_bloc.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/constant_term_of_use.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

import '../../../networking/api_response.dart';
import '../../../reusable_widgets/appBar/custom_appbar.dart';
import '../../../utils/constant_images.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late SettingBloc _bloc;

  @override
  void didChangeDependencies() {
    if (mounted) {
      _bloc = SettingBloc(context)..setInitialData();
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
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              showBackButton: false,
              onTap: () {},
              title: ConstantStrings.SETTINGS,
            ),
          ),
          body: ListView(children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: context.height / 20,
                  ),
                  const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(ConstantImages.APP_LOGO)),
                  SizedBox(
                    height: context.height / 100,
                  ),
                  StreamBuilder<String>(
                      initialData: "",
                      stream: _bloc.name,
                      builder: (context, snapshot) {
                        return Text(snapshot.data!);
                      }),
                  SizedBox(
                    height: context.height / 20,
                  ),
                ]),
            const Divider(
              color: ConstantColors.appPrimaryColor,
              thickness: 1,
              height: 1,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const ResetPasswordScreen()));
              },
              title: const Text(
                "Reset Password",
              ),
              leading: const Icon(
                Icons.lock_reset_rounded,
                color: ConstantColors.appPrimaryColor,
              ),
            ),
            const Divider(
              color: ConstantColors.appPrimaryColor,
              thickness: 1,
              height: 1,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const TermsOfUse()));
              },
              title: const Text(
                "Terms of Use",
              ),
              leading: const Icon(
                Icons.indeterminate_check_box_sharp,
                color: ConstantColors.appPrimaryColor,
              ),
            ),
            // const Divider(
            //   color: ConstantColors.appPrimaryColor,
            //   thickness: 1,
            //   height: 1,
            // ),
            // const ListTile(
            //   title: Text(
            //     "Privacy & Policy",
            //   ),
            //   leading: Icon(
            //     Icons.policy,
            //     color: ConstantColors.appPrimaryColor,
            //   ),
            // ),
            const Divider(
              color: ConstantColors.appPrimaryColor,
              thickness: 1,
              height: 1,
            ),
            ListTile(
              title: const Text(
                "Logout",
              ),
              onTap: () {
                showDialogMethod(context);
              },
              leading: const Icon(
                Icons.logout,
                color: ConstantColors.appPrimaryColor,
              ),
            )
          ])),
    );
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
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(ConstantStrings.SURE_LOGOUT,
                            style: poppinsTextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                textColor: ConstantColors.appBlackColor)),
                      ],
                    ),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      GestureDetector(
                        onTap: isLoading
                            ? () {}
                            : () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
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

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          showBackButton: true,
          onTap: () {
            Navigator.pop(context);
          },
          title: "Terms of Use",
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(
            left: context.width / 40,
            right: context.width / 40,
            top: context.height / 50),
        child: ListView(
          children: [
            Text(
              TermsOfUser.TOP_HEADING,
              style: poppinsTextStyle(
                  fontWeight: FontWeight.bold, fontSize: context.width * 0.06),
            ),
            Text(
              TermsOfUser.TOP_PARAGRAPH,
              style: poppinsTextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: context.width * 0.06),
            ),
            HeadingWidget(text: TermsOfUser.HEADING_1),
            ParagraphWidget(
              text: TermsOfUser.PARAGRAPH_1,
            ),
            HeadingWidget(text: TermsOfUser.HEADING_2),
            ParagraphWidget(
              text: TermsOfUser.PARAGRAPH_2,
            ),
            PointWidget(point: TermsOfUser.POINT_1),
            PointWidget(point: TermsOfUser.POINT_2),
            PointWidget(point: TermsOfUser.POINT_3),
            PointWidget(point: TermsOfUser.POINT_4),
            HeadingWidget(text: TermsOfUser.HEADING_3),
            ParagraphWidget(
              text: TermsOfUser.PARAGRAPH_3,
            ),
            HeadingWidget(text: TermsOfUser.HEADING_4),
            ParagraphWidget(
              text: TermsOfUser.PARAGRAPH_4,
            ),
            HeadingWidget(text: TermsOfUser.HEADING_5),
            ParagraphWidget(
              text: TermsOfUser.PARAGRAPH_5,
            ),
            HeadingWidget(text: TermsOfUser.HEADING_6),
            ParagraphWidget(
              text: TermsOfUser.PARAGRAPH_6,
            ),
            HeadingWidget(text: TermsOfUser.HEADING_7),
            ParagraphWidget(
              text: TermsOfUser.PARAGRAPH_7,
            ),
            HeadingWidget(text: TermsOfUser.HEADING_8),
            ParagraphWidget(
              text: TermsOfUser.PARAGRAPH_8,
            ),
            const SizedBox(
              height: kBottomNavigationBarHeight,
            )
          ],
        ),
      )),
    );
  }
}

class PointWidget extends StatelessWidget {
  const PointWidget({
    super.key,
    required this.point,
  });
  final String point;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: context.width / 50,
        ),
        Padding(
          padding: EdgeInsets.only(top: context.width / 50),
          child: Container(
            width: context.width / 45,
            height: context.width / 45,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: ConstantColors.appBlackColor),
          ),
        ),
        SizedBox(
          width: context.width / 50,
        ),
        SizedBox(
          width: context.width / 1.2,
          child: Text(
            point,
            style: poppinsTextStyle(
                fontWeight: FontWeight.normal, fontSize: context.width * 0.04),
          ),
        )
      ],
    );
  }
}

class ParagraphWidget extends StatelessWidget {
  const ParagraphWidget({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: poppinsTextStyle(
          fontWeight: FontWeight.normal, fontSize: context.width * 0.04),
    );
  }
}

class HeadingWidget extends StatelessWidget {
  const HeadingWidget({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: context.height / 30,
        ),
        Text(
          text,
          style: poppinsTextStyle(
              fontWeight: FontWeight.bold, fontSize: context.width * 0.05),
        ),
      ],
    );
  }
}
