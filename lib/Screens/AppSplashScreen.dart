import 'dart:async';

import 'package:ehs_new/utils/AppConstant.dart';
import 'package:ehs_new/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'CompanyName.dart';



class AppSplashScreen extends StatefulWidget {
  static String tag = '/AppSplashScreen';

  @override
  _AppSplashScreenState createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    navigationPage();
  }

  void navigationPage() async {
    await setInt(appOpenCount, (await getInt(appOpenCount)) + 1);

    if (!await isNetworkAvailable()) {
      toastLong(errorInternetNotAvailable);
    }

    await Future.delayed(Duration(seconds: 1));
    // if (!isMobile) {
    //   ProKitWebLauncher().launch(context, isNewTask: true);
    //   //ProKitLauncher().launch(context, isNewTask: true);
    // } else {
    CompanyName().launch(context, isNewTask: true);
    // }
  }

  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: getColorFromHex('#FFFDF1'),
    //   body: Container(
    //     alignment: Alignment.center,
    //     child: Image.asset('images/app/icons/app_icon.png', height: 50, fit: BoxFit.fitHeight),
    //   ),
    // );
    return Scaffold(
      backgroundColor: bg,
      body: Container(
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background/bg.png"),
            fit: BoxFit.cover,
          ),
        )*/
        child: SafeArea(
          child: Center(
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: new Image.asset("images/app/icons/eshlogo.png")
              )
            )
        ), /* add child content here */
      )
    );
  }
}
