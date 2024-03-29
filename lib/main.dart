import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'Screens/AppSplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize hive
  await Hive.initFlutter();
  //open the box
  await Hive.openBox('mybox');

  runApp(MyApp());
  BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 1, // Minimum fetch interval in minutes
      stopOnTerminate: false,
      enableHeadless: false, // No custom headless task handler needed
      startOnBoot: true,
    ),
    (String taskId) async {
      // This callback will be executed when a background fetch event occurs.

      // You can use the `taskId` within this callback function if needed.
      print("Background fetch task started with taskId: $taskId");

      // Check internet connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // Perform your API request here
        // Handle the data as needed
      }

      // Finish the background fetch task to signal its completion
      BackgroundFetch.finish(taskId);
    },
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Observer(
      builder: (_) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppSplashScreen(),
        builder: scrollBehaviour(),
      ),
    );
  }
}
