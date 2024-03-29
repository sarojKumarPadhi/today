import 'dart:convert';

import 'package:ehs_new/utils/AppConstant.dart';
import 'package:ehs_new/utils/Session.dart';
import 'package:ehs_new/utils/String.dart';
import 'package:ehs_new/utils/color.dart';
import 'package:ehs_new/widget/AppWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'CompanyName.dart';
import 'Dashboard.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  static String tag = '/CompanyName';
  String companyName, loginName;
  Login({required this.companyName, required this.loginName}) : super();

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> with TickerProviderStateMixin {
  bool loginSuccessful = true;
  bool showPassword = false;
  late String tanentId;

  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  late String username, password;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;
  late SharedPreferences prefs;
  late String token;

  @override
  void initState() {
    super.initState();
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    buttonSqueezeanimation = new Tween(
      begin: 0 * 0.7,
      end: 50.0,
    ).animate(new CurvedAnimation(
      parent: buttonController,
      curve: new Interval(0.0, 0.150),
    ));
  }

  Future<void> getGenerateToken(String tanentName) async {
    showLoaderDialog(context);
    var redirectUri = "https://$tanentName.dev-ehswatch.com/";
    var data = {
      GRANT_TYPE: "password",
      SCOPE:
          "IdentityService SaasService ObservationsService AdministrationService EmployeeService IncidentService InspectionService UserTaskService ActionService AttachmentService",
      USERNAME: username,
      PASSWORD: password,
      CLIENT_ID: "EHSWatch_MobileApp",
      CLIENT_SECRET: "Exceego@890",
      REDIRECT_URI: redirectUri,
      '__tenant': tanentName,
    };

    // Print the redirect URL
    print("Redirect URL: $redirectUri");
    print("TENANT NAME: $tanentName");

    Response response = await post(getToken, body: data, headers: headersUsers)
        .timeout(Duration(seconds: timeOut));
    var getData = json.decode(response.body);
    var token = getData["access_token"];
    save(token);
    retrive();
    print("LOGIN TOKEN    " + token);
    print("hvhvh    " + getData["scope"]);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Dashboard(
          tenantName: tanentName,
          username: username,
          password: password,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: bg,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formkey,
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 100, bottom: 50, left: 20, right: 20),
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: <Widget>[
                              if (widget.companyName.toLowerCase() == "exceego")
                                Container(
                                    width: 150,
                                    child: Image.network(logoUrlExceego +
                                        widget.companyName +
                                        ".png")),
                              if (widget.companyName.toLowerCase() != "exceego")
                                Container(
                                    width: 200,
                                    child: Image.network(
                                        logoUrl + widget.companyName + ".png")),
                              SizedBox(height: 40),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Center(
                                  child: Text(
                                    'Enter your details to login to your account',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontFamily: 'RocgroTesk',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: border),
                                ),
                                padding: EdgeInsets.all(0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: usernameTextController,
                                        style: TextStyle(
                                          fontSize: textSizeMedium,
                                          fontFamily: 'Inter',
                                        ),
                                        decoration: InputDecoration(
                                          counterText: "",
                                          contentPadding:
                                              EdgeInsets.fromLTRB(16, 0, 16, 0),
                                          hintText: Ehs_hint_user_name,
                                          hintStyle: TextStyle(
                                            color: hintColor,
                                            fontSize: textSizeMedium,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        validator: (val) => validateUserName(
                                            val!, USER_REQUIRED),
                                        onSaved: (String? value) {
                                          username = value!;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          Color(0xFF145d87),
                                          BlendMode.srcIn,
                                        ),
                                        child: Image.asset(
                                          'images/app/icons/user.png',
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: border),
                                ),
                                padding: EdgeInsets.all(0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        obscureText: !showPassword,
                                        controller: passwordTextController,
                                        style: TextStyle(
                                          fontSize: textSizeMedium,
                                          fontFamily: 'Inter',
                                        ),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                          counterText: "",
                                          contentPadding:
                                              EdgeInsets.fromLTRB(16, 0, 16, 0),
                                          hintText: Ehs_hint_password,
                                          hintStyle: TextStyle(
                                            color: hintColor,
                                            fontSize: textSizeMedium,
                                          ),
                                          border: InputBorder.none,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Color(0xFF145d87),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                showPassword = !showPassword;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (val) => validatePass(
                                            val!, PWD_REQUIRED, PWD_LENGTH),
                                        onSaved: (String? value) {
                                          password = value!;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              loginButton(),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CompanyName()),
                                  );
                                },
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                      color: Color(0xFF145d87),
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formkey.currentState;
    form?.save();
    print(username + password);
    if (form!.validate()) {
      return true;
    }
    return true;
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        await _playAnimation();
        await getGenerateToken(widget.companyName);
        loginSuccessful = true;
      } catch (e) {
        print("Invalid login credentials");
        Fluttertoast.showToast(
          msg: "Invalid login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        loginSuccessful = false;
        Navigator.pop(context);
      } finally {
        buttonController.reset();

        if (loginSuccessful) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                tenantName: widget.companyName,
                username: username,
                password: password,
              ),
            ),
          );
        }
      }
    }
  }

  loginButton() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(8),
      color: Color(0xFF145d87),
      child: InkWell(
        onTap: () {
          validateAndSubmit();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 55,
          width: 500,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Center(
            child: Text(
              Ehs_lbl_login,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                fontSize: 16,
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

  retrive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString(TOKEN);
    setState(() => token = _token!);
  }
}
