import 'dart:convert';

import 'package:ehs_new/utils/AppConstant.dart';
import 'package:ehs_new/utils/Choice.dart';
import 'package:ehs_new/utils/Session.dart';
import 'package:ehs_new/utils/String.dart';
import 'package:ehs_new/widget/AppWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'Audits/AuditCreate.dart';
import 'Audits/AuditsList.dart';
import 'Incident Managements/IncidentCreate.dart';
import 'Incident Managements/IncidentList.dart';
import 'Inspections/IncpectionCreate.dart';
import 'Inspections/InspectionList.dart';
import 'Observation/ObservationCreate.dart';
import 'Observation/ObservationList.dart';
import 'Settings.dart';

class Dashboard extends StatefulWidget {
  static String tag = '/Dashboard';
  final String tenantName;
  final String username;
  final String password;

  Dashboard(
      {required this.tenantName,
      required this.username,
      required this.password});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var title = "Dashboard";
  late String token;
  late SharedPreferences prefs;
  var list = <Choice>[];
  bool obsSrevice = false,
      actService = false,
      incidentService = false,
      inspectionService = false,
      adminService = false,
      auditService = false;

  @override
  void initState() {
    super.initState();
    getGenerateToken(widget.tenantName, widget.username, widget.password);
  }

  // Future<void> getGenerateToken() async {
  //   var data = {
  //     GRANT_TYPE: "password",
  //     SCOPE:
  //         "IdentityService SaasService ObservationsService AdministrationService EmployeeService IncidentService InspectionService UserTaskService ActionService AttachmentService",
  //     USERNAME: "Exadmin",
  //     PASSWORD: "Exceego@4477",
  //     CLIENT_ID: "EHSWatch_MobileApp",
  //     CLIENT_SECRET: "Exceego@890",
  //     REDIRECT_URI: "https://dev-ehswatch.com/"
  //   };

  //   Response response = await post(getToken, body: data, headers: headersUsers)
  //       .timeout(Duration(seconds: timeOut));
  //   print(response.body);
  //   var getData = json.decode(response.body);
  //   var token = getData["access_token"];
  //   save(token);
  //   retrive();
  // }

  Future<void> getGenerateToken(
      String companyName, String username, String password) async {
    var data = {
      GRANT_TYPE: "password",
      SCOPE:
          "IdentityService SaasService ObservationsService AdministrationService EmployeeService IncidentService InspectionService UserTaskService ActionService AttachmentService",
      USERNAME: username,
      PASSWORD: password,
      CLIENT_ID: "EHSWatch_MobileApp",
      CLIENT_SECRET: "Exceego@890",
      REDIRECT_URI: "https://dev-ehswatch.com/",
      'tenant': companyName,
    };

    Response response = await post(getToken, body: data, headers: headersUsers)
        .timeout(Duration(seconds: timeOut));

    if (response.statusCode == 200) {
      var getData = json.decode(response.body);
      var token = getData["access_token"];
      save(token);
      retrive();
    } else {
      if (response.statusCode == 401) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to generate token');
      }
    }
  }

  save(String token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(TOKEN, token);
  }

  retrive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString(TOKEN);
    setState(() => token = _token!);
    getFeatures();
  }

  Map<String, String> get headers => {
        "Authorization": 'bearer ' + token,
      };

  Future<void> getFeatures() async {
    showLoaderDialog(context);
    Response response = await get(getFeature, headers: headers)
        .timeout(Duration(seconds: timeOut));
    print(response.body);
    var getData = json.decode(response.body);
    setState(() {
      for (var i = 0; i < getData["groups"].length; i++) {
        if (getData["groups"][i]["name"] == OBSERVATION) {
          if (getData["groups"][i]["features"][0]["value"] == "True") {
            list.add(Choice(title: menu_observation, icon: image_observations));
            obsSrevice = true;
          }
        }
        if (getData["groups"][i]["name"] == INCIDENTS) {
          if (getData["groups"][i]["features"][0]["value"] == "True") {
            list.add(Choice(title: menu_incidents, icon: image_incidents));
            incidentService = true;
          }
        }
        if (getData["groups"][i]["name"] == INSPECTION) {
          if (getData["groups"][i]["features"][0]["value"] == "True") {
            list.add(Choice(title: menu_inspections, icon: image_inspections));
            inspectionService = true;
          }
        }
        if (getData["groups"][i]["name"] == AUDIT) {
          if (getData["groups"][i]["features"][0]["value"] == "True") {
            list.add(Choice(title: menu_audits, icon: image_audits));
            auditService = true;
          }
        }
      }
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Dashboard',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'RocgroTesk',
                fontSize: textSizeLargeMedium,
                fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ));
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: new Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
              ),
            )
          ],
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(children: [
            SizedBox(
              height: 1,
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(left: 80),
              child: Row(
                children: [
                  Image.asset(
                    'images/app/icons/Link_logo.png',
                    width: 70,
                    height: 70,
                  ),
                  Text(
                    "Quick Links",
                    style: TextStyle(
                      color: Color(0xFF145d87),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'RocgroTesk',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final choice = list[index];
                    String logoImagePath = '';

                    if (choice.title == menu_observation) {
                      logoImagePath = 'images/app/menu/observations.png';
                    } else if (choice.title == menu_incidents) {
                      logoImagePath = 'images/app/menu/incidents.png';
                    } else if (choice.title == menu_audits) {
                      logoImagePath = 'images/app/menu/inspections.png';
                    } else if (choice.title == menu_inspections) {
                      logoImagePath = 'images/app/menu/audits.png';
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFF145d87),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (logoImagePath.isNotEmpty)
                                  Image.asset(
                                    logoImagePath,
                                    width: 30,
                                    height: 30,
                                  ),
                                SizedBox(width: 10),
                                Text(
                                  choice.title,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'RocgroTesk',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (choice.title == menu_observation) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ObservationCreate(),
                                        ),
                                      );
                                    } else if (choice.title == menu_incidents) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              IncidentCreate(),
                                        ),
                                      );
                                    } else if (choice.title == menu_audits) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AuditCreate(),
                                        ),
                                      );
                                    } else if (choice.title ==
                                        menu_inspections) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InspectionCreate(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'New',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'RocgroTesk'),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (choice.title == menu_observation) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ObservationList(),
                                        ),
                                      );
                                    } else if (choice.title == menu_incidents) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => IncidentList(),
                                        ),
                                      );
                                    } else if (choice.title == menu_audits) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AuditsList(),
                                        ),
                                      );
                                    } else if (choice.title ==
                                        menu_inspections) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InspectionList(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.list,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'List',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'RocgroTesk'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

// import 'dart:convert';

// import 'package:ehs_new/utils/AppConstant.dart';
// import 'package:ehs_new/utils/Choice.dart';
// import 'package:ehs_new/utils/String.dart';
// import 'package:ehs_new/widget/AppWidget.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'Audits/AuditCreate.dart';
// import 'Audits/AuditsList.dart';
// import 'Incident Managements/IncidentCreate.dart';
// import 'Incident Managements/IncidentList.dart';
// import 'Inspections/IncpectionCreate.dart';
// import 'Inspections/InspectionList.dart';
// import 'Observation/ObservationCreate.dart';
// import 'Observation/ObservationList.dart';
// import 'Settings.dart';

// class Dashboard extends StatefulWidget {
//   static String tag = '/Dashboard';
//   final String tenantName;
//   final String username;
//   final String password;

//   Dashboard({
//     required this.tenantName,
//     required this.username,
//     required this.password,
//   });

//   @override
//   DashboardState createState() => DashboardState();
// }

// class DashboardState extends State<Dashboard> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   var title = "Dashboard";
//   late String token;
//   late SharedPreferences prefs;
//   var list = <Choice>[];
//   bool obsSrevice = false,
//       actService = false,
//       incidentService = false,
//       inspectionService = false,
//       adminService = false,
//       auditService = false;

//   @override
//   void initState() {
//     super.initState();
//     retrive();
//   }

//   Map<String, String> get headers => {
//         "Authorization": 'bearer ' + token,
//       };

//   Future<void> getFeatures() async {
//     //showLoaderDialog(context);
//     try {
//       if (!mounted) return;
//       showLoaderDialog(context);
//       Response response = await get(getFeature, headers: headers)
//           .timeout(Duration(seconds: timeOut));
//       print(response.body);
//       var getData = json.decode(response.body);
//       if (mounted) {
//         setState(() {
//           list.clear();
//           for (var i = 0; i < getData["groups"].length; i++) {
//             if (getData["groups"][i]["name"] == OBSERVATION) {
//               if (getData["groups"][i]["features"][0]["value"] == "True") {
//                 list.add(
//                     Choice(title: menu_observation, icon: image_observations));
//                 obsSrevice = true;
//               }
//             }
//             if (getData["groups"][i]["name"] == INCIDENTS) {
//               if (getData["groups"][i]["features"][0]["value"] == "True") {
//                 list.add(Choice(title: menu_incidents, icon: image_incidents));
//                 incidentService = true;
//               }
//             }
//             if (getData["groups"][i]["name"] == INSPECTION) {
//               if (getData["groups"][i]["features"][0]["value"] == "True") {
//                 list.add(
//                     Choice(title: menu_inspections, icon: image_inspections));
//                 inspectionService = true;
//               }
//             }
//             if (getData["groups"][i]["name"] == AUDIT) {
//               if (getData["groups"][i]["features"][0]["value"] == "True") {
//                 list.add(Choice(title: menu_audits, icon: image_audits));
//                 auditService = true;
//               }
//             }
//           }
//         });
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     } finally {
//       if (mounted) {
//         Navigator.pop(context);
//       }
//     }
//   }

//   retrive() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? _token = prefs.getString(TOKEN);

//     if (mounted) {
//       setState(() {
//         token = _token!;
//         getFeatures();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         key: scaffoldKey,
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//           elevation: 0,
//           title: const Text(
//             'Dashboard',
//             style: TextStyle(
//                 color: Colors.black,
//                 fontFamily: 'RocgroTesk',
//                 fontSize: textSizeLargeMedium,
//                 fontWeight: FontWeight.w500),
//           ),
//           actions: <Widget>[
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Settings(),
//                     ));
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(right: 20),
//                 child: new Icon(
//                   Icons.settings,
//                   color: Colors.black,
//                 ),
//               ),
//             )
//           ],
//           backgroundColor: Colors.white,
//         ),
//         body: Center(
//           child: Column(children: [
//             SizedBox(
//               height: 1,
//             ),
//             Container(
//               alignment: Alignment.topCenter,
//               padding: EdgeInsets.only(left: 80),
//               child: Row(
//                 children: [
//                   Image.asset(
//                     'images/app/icons/Link_logo.png',
//                     width: 70,
//                     height: 70,
//                   ),
//                   Text(
//                     "Quick Links",
//                     style: TextStyle(
//                       color: Color(0xFF145d87),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30,
//                       fontFamily: 'RocgroTesk',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListView.builder(
//                   itemCount: list.length,
//                   itemBuilder: (context, index) {
//                     final choice = list[index];
//                     String logoImagePath = '';

//                     if (choice.title == menu_observation) {
//                       logoImagePath = 'images/app/menu/observations.png';
//                     } else if (choice.title == menu_incidents) {
//                       logoImagePath = 'images/app/menu/incidents.png';
//                     } else if (choice.title == menu_audits) {
//                       logoImagePath = 'images/app/menu/inspections.png';
//                     } else if (choice.title == menu_inspections) {
//                       logoImagePath = 'images/app/menu/audits.png';
//                     }
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Color(0xFF145d87),
//                         ),
//                         padding: EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 if (logoImagePath.isNotEmpty)
//                                   Image.asset(
//                                     logoImagePath,
//                                     width: 30,
//                                     height: 30,
//                                   ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   choice.title,
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     fontFamily: 'RocgroTesk',
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 20),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     if (choice.title == menu_observation) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ObservationCreate(),
//                                         ),
//                                       );
//                                     } else if (choice.title == menu_incidents) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               IncidentCreate(),
//                                         ),
//                                       );
//                                     } else if (choice.title == menu_audits) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => AuditCreate(),
//                                         ),
//                                       );
//                                     } else if (choice.title ==
//                                         menu_inspections) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               InspectionCreate(),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.add,
//                                         color: Colors.white,
//                                       ),
//                                       SizedBox(width: 5),
//                                       Text(
//                                         'New',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontFamily: 'RocgroTesk'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     if (choice.title == menu_observation) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ObservationList(),
//                                         ),
//                                       );
//                                     } else if (choice.title == menu_incidents) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => IncidentList(),
//                                         ),
//                                       );
//                                     } else if (choice.title == menu_audits) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => AuditsList(),
//                                         ),
//                                       );
//                                     } else if (choice.title ==
//                                         menu_inspections) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               InspectionList(),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.list,
//                                         color: Colors.white,
//                                       ),
//                                       SizedBox(width: 5),
//                                       Text(
//                                         'List',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontFamily: 'RocgroTesk'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             )
//           ]),
//         ),
//       ),
//     );
//   }
// }
