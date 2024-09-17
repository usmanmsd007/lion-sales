import 'package:flutter/material.dart';
import 'package:lion_sales/utils/extensions.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Looks like your app is out of date\n Please update your app.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: context.height / 30,
          ),
          // ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //         backgroundColor: ConstantColors.appPrimaryColor),
          //     onPressed: () async {
          //       if (Platform.isAndroid) {
          //         String appPackageName = "com.tencent.ig";
          //
          //         await launchUrl(Uri.parse(
          //             'https://play.google.com/store/apps/details?id=$appPackageName&hl=en&gl=US'));
          //       }
          //       if (Platform.isIOS) {
          //         String appStoreId = "1330123889";
          //         await launchUrl(
          //             Uri.parse('https://apps.apple.com/app/id=$appStoreId'));
          //       }
          //     },
          //     child: const Text("Update"))
        ],
      )),
    );
  }
}
