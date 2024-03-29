import 'dart:async';
import 'dart:convert';

import 'package:ehs_new/utils/AppConstant.dart';
import 'package:ehs_new/utils/color.dart';
import 'package:ehs_new/widget/AppWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Model/TanentsModel.dart';
import '../Utils/Session.dart';
import '../Utils/String.dart';
import 'Login.dart';

class CompanyName extends StatefulWidget {
  static String tag = '/CompanyName';

  @override
  CompanyNameState createState() => CompanyNameState();
}

class CompanyNameState extends State<CompanyName> {
  TextEditingController companyTextController = TextEditingController();
  late SharedPreferences prefs;
  late String token;
  var positionSelection;
  List<TanentsModel> tanents = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoggedIn = true;
  @override
  void initState() {
    super.initState();
    getGenerateToken();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    String message;
    if (connectivityResult == ConnectivityResult.wifi) {
      print('Connected to Wi-Fi');
      message = 'Connected to Wi-Fi';
      // Handle Wi-Fi connection
    } else if (connectivityResult == ConnectivityResult.mobile) {
      print('Connected to Mobile Data');
      message = 'Connected to Mobile Data';
      // Handle mobile data connection
    } else {
      print('No network connection');
      message = 'No network connection';
    }

    // Show Snackbar
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> getGenerateToken() async {
    var data = {
      GRANT_TYPE: "password",
      SCOPE: "IdentityService SaasService AdministrationService",
      USERNAME: "mounica",
      PASSWORD: "Exceego@123",
      CLIENT_ID: "EHSWatch_MobileApp",
      CLIENT_SECRET: "Exceego@890",
      REDIRECT_URI: "https://dev-ehswatch.com/"
    };

    Response response = await post(getToken, body: data, headers: headersUsers)
        .timeout(Duration(seconds: timeOut));
    print(response.body);
    var getData = json.decode(response.body);
    print("error  " + getData["access_token"]);
    if (getData["access_token"] != Error) {
      var token = getData["access_token"];
      save(token);
      retrive();
      print("hvhvh    " + token);
    }
  }

  Map<String, String> get headers => {
        "Authorization": 'bearer ' + token,
      };

  Future<void> checkTenantAvailability(String tanentName) async {
    showLoaderDialog(context);
    Response response = await get(getTanent, headers: headers)
        .timeout(Duration(seconds: timeOut));
    var allTanentsData = json.decode(response.body);

    Navigator.pop(context);

    List<String> allTanents = [];
    var tanentItems = allTanentsData["items"];
    for (var tanentItem in tanentItems) {
      allTanents.add(tanentItem["name"]);
    }

    if (allTanents.contains(tanentName)) {
      saveCompany(tanentName);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(
            companyName: tanentName,
            loginName: '',
          ),
        ),
      ).then(onGoBack);
    } else {
      Fluttertoast.showToast(msg: "Tenant not available");
    }
  }

  Future<void> getTanents() async {
    showLoaderDialog(context);
    Response response = await get(getTanent, headers: headers)
        .timeout(Duration(seconds: timeOut));

    var getData = json.decode(response.body);
    List<String> availableTanents = [];

    setState(() {
      var count = getData["items"].length;
      for (int i = 0; i < count; i++) {
        var tanentItem = getData["items"][i];
        String tanentName = tanentItem['name'];
        availableTanents.add(tanentName);
        print(tanentName);
      }
    });

    Navigator.pop(context);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      getTanents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isLoggedIn) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: bg,
        body: SingleChildScrollView(
          child: Container(
            /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background/bg.png"),
            fit: BoxFit.cover,
          ),
        ),*/
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(
                        child: Image.asset(
                          'images/app/icons/login_logo.png',
                          height: 280,
                          width: 900,
                        ),
                      ),
                    ),
                    SizedBox(height: .1),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 20,
                          ),
                          child: Column(
                            children: <Widget>[
                              SvgPicture.asset(
                                'images/app/icons/ehs.svg',
                                height: 60,
                                width: 60,
                              ),
                              SizedBox(height: 50),
                              Text(
                                "Enter Your Tenant Details",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                  fontFamily: 'RocgroTesk',
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: companyTextController,
                                decoration: InputDecoration(
                                  hintText: "Enter Tenant",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF145d87),
                                    fontFamily: 'Inter',
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF145d87),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: TextStyle(
                                  color: headerColor,
                                  fontFamily: 'Inter',
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    positionSelection = newValue;
                                  });
                                },
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: 375,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF145d87),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    checkTenantAvailability(
                                        companyTextController.text);
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Center(
                                    child: Text(
                                      Ehs_lbl_continue,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  save(String token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(TOKEN, token);
  }

  saveCompany(String company) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(COMPANY, company);
  }

  retrive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString(TOKEN);
    setState(() => token = _token!);
    getTanents();
  }
}
