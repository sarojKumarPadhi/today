import 'dart:async';
import 'dart:convert';

import 'package:ehs_new/Model/ObservationModel.dart';
import 'package:ehs_new/utils/AppConstant.dart';
import 'package:ehs_new/utils/String.dart';
import 'package:ehs_new/utils/color.dart';
import 'package:ehs_new/widget/AppWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ObservationCreate.dart';
import 'ObservationEdit.dart';
import 'ObservationView.dart';

class ObservationList extends StatefulWidget {
  static String tag = '/Observation';

  @override
  ObservationListState createState() => ObservationListState();
}

class ObservationListState extends State<ObservationList> {
  late String token;
  List<ObservationModel> observation = [];

  @override
  void initState() {
    super.initState();
    retrive();
  }

  Map<String, String> get headers => {
        "Authorization": 'bearer ' + token,
      };

  Future<void> getObservationList() async {
    showLoaderDialog(context);
    Response response = await get(getObservation, headers: headers)
        .timeout(Duration(seconds: timeOut));
    print(response.body);
    var getData = json.decode(response.body);
    print(getData["items"].length);
    observation.clear();
    setState(() {
      var count = getData["items"].length;
      for (int i = 0; i < count; i++) {
        var observationItems = getData["items"][i];
        print("________OBS ITEMS_________: ${observationItems}");
        ObservationModel observationModel = ObservationModel(
            observationItems['observation']['recordNo'] != null
                ? observationItems['observation']['recordNo']
                : " ",
            observationItems['observation']['observationDate'] != null
                ? observationItems['observation']['observationDate']
                : " ",
            observationItems['observation']['observationStage'] != null
                ? observationItems['observation']['observationStage']
                : " ",
            observationItems['observation']['reportedDateAndTime'] != null
                ? observationItems['observation']['reportedDateAndTime']
                : " ",
            observationItems['observation']['id'] != null
                ? observationItems['observation']['id']
                : " ",
            observationItems['observationOrganizationDisplayName'] != null
                ? observationItems['observationOrganizationDisplayName']
                : " ",
            observationItems['observationReportingByDisplayName'] != null
                ? observationItems['observationReportingByDisplayName']
                : " ",
            observationItems['observationReviewedByDisplayName'] != null
                ? observationItems['observationReviewedByDisplayName']
                : " ",
            observationItems['observationObservationTypeDisplayName'] != null
                ? observationItems['observationObservationTypeDisplayName']
                : " ",
            observationItems['observation']['exactLocation'] != null
                ? observationItems['observation']['exactLocation']
                : " ",
            observationItems['observation']['time'] != null
                ? observationItems['observation']['time']
                : " ",
            observationItems['observation']['description'] != null
                ? observationItems['observation']['description']
                : " ",
            observationItems[
                        'observationPersonalProtectiveEquipmentDisplayName'] !=
                    null
                ? observationItems[
                    'observationPersonalProtectiveEquipmentDisplayName']
                : " ",
            observationItems['observationReactionOfPeopleDisplayName'] != null
                ? observationItems['observationReactionOfPeopleDisplayName']
                : " ",
            observationItems['observationPerceivedRiskOrOpportunityDisplayName'] !=
                    null
                ? observationItems[
                    'observationPerceivedRiskOrOpportunityDisplayName']
                : " ",
            observationItems['observationUnsafeActTypeDisplayName'] != null
                ? observationItems['observationUnsafeActTypeDisplayName']
                : " ",
            observationItems['observation']['comments'] != null
                ? observationItems['observation']['comments']
                : " ",
            observationItems['observation']['dateReviewed'] != null
                ? observationItems['observation']['dateReviewed']
                : " ",
            observationItems['observation']['hseReviewerComment'] != null
                ? observationItems['observation']['hseReviewerComment']
                : " ");
        observation.add(observationModel);
      }
    });
    Navigator.pop(context);
  }

  Future<void> observationDelete(String id, int index) async {
    showLoaderDialog(context);
    Response response = await delete(
            Uri.parse(
                baseUrlTenants + 'observations-service/observations/' + id),
            headers: headers)
        .timeout(Duration(seconds: timeOut));
    print(response.statusCode);
    if (response.statusCode == 204) {
      setState(() {
        observation.removeAt(index);
      });
    } else {
      var getData = json.decode(response.body);
      String error = getData["error"]["message"];
      print(error);
    }
    Navigator.pop(context);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      getObservationList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
        //   Scaffold(
        //   backgroundColor: bg,
        //   appBar: AppBar(
        //     iconTheme: IconThemeData(color: Colors.black),
        //     title: const Text(
        //       'OBSERVATION LIST',
        //       style: TextStyle(
        //         fontFamily: 'Inter',
        //         fontWeight: FontWeight.w700,
        //         color: Colors.black,
        //         fontSize: textSizeMedium,
        //       ),
        //     ),
        //     backgroundColor: bg,
        //     centerTitle: true,
        //     elevation: 0,
        //     actions: <Widget>[
        //       IconButton(
        //         icon: Icon(Icons.add, color: Colors.black),
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => ObservationCreate()),
        //           );
        //         },
        //       ),
        //     ],
        //   ),
        //   body: Container(
        //     child: ListView.builder(
        //         scrollDirection: Axis.vertical,
        //         itemCount: observation.length,
        //         shrinkWrap: true,
        //         itemBuilder: (context, index) {
        //           return Container(
        //             margin: EdgeInsets.all(16),
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(10),
        //                 boxShadow: defaultBoxShadow(),
        //                 color: Colors.white),
        //             child: Stack(
        //               children: <Widget>[
        //                 Column(
        //                   children: <Widget>[
        //                     Padding(
        //                       padding: EdgeInsets.only(
        //                           left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
        //                       child: Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: <Widget>[
        //                           SizedBox(height: 8),
        //                           Row(
        //                             crossAxisAlignment: CrossAxisAlignment.start,
        //                             mainAxisAlignment:
        //                             MainAxisAlignment.spaceBetween,
        //                             children: <Widget>[
        //                               Column(
        //                                 mainAxisAlignment: MainAxisAlignment.start,
        //                                 crossAxisAlignment:
        //                                 CrossAxisAlignment.start,
        //                                 children: <Widget>[
        //                                   Container(
        //                                     child: Text("Observation Number",
        //                                         style: TextStyle(
        //                                             color: listHeadingColor,
        //                                             fontSize: 14,
        //                                             fontFamily: 'Inter'),
        //                                         textAlign: TextAlign.left),
        //                                   ),
        //                                   Container(
        //                                     child: Text(observation[index].recordNo,
        //                                         style: TextStyle(
        //                                             color: Colors.black,
        //                                             fontSize: 15,
        //                                             fontFamily: 'Inter',
        //                                             fontWeight: FontWeight.w600),
        //                                         textAlign: TextAlign.left),
        //                                   ),
        //                                   SizedBox(height: 4),
        //                                   Container(
        //                                     child: Text("Observation Date",
        //                                         style: TextStyle(
        //                                             color: listHeadingColor,
        //                                             fontSize: 14,
        //                                             fontFamily: 'Inter'),
        //                                         textAlign: TextAlign.left),
        //                                   ),
        //                                   Container(
        //                                     padding:
        //                                     EdgeInsets.fromLTRB(0, 0, 10, 0),
        //                                     child: Text(
        //                                         observation[index]
        //                                             .observationDate
        //                                             .split("T")[0],
        //                                         style: TextStyle(
        //                                             fontSize: 15,
        //                                             color: Colors.black,
        //                                             fontFamily: 'Inter',
        //                                             fontWeight: FontWeight.w600),
        //                                         maxLines: 2),
        //                                   ),
        //                                 ],
        //                               ),
        //                               Container(
        //                                 padding: const EdgeInsets.all(10),
        //                                 decoration: boxDecoration(
        //                                     showShadow: false,
        //                                     bgColor: getColor(observation[index]
        //                                         .observationStage),
        //                                     radius: 8),
        //                                 child: Text(
        //                                     "Stage : " +
        //                                         observation[index].observationStage,
        //                                     style: TextStyle(
        //                                         color: Colors.white,
        //                                         fontSize: 12,
        //                                         fontFamily: 'Inter'),
        //                                     textAlign: TextAlign.right),
        //                               ),
        //                             ],
        //                           ),
        //                           SizedBox(height: 20),
        //                           Row(
        //                             mainAxisAlignment:
        //                             MainAxisAlignment.spaceBetween,
        //                             children: <Widget>[
        //                               InkWell(
        //                                 onTap: () {
        //                                   Navigator.push(
        //                                     context,
        //                                     MaterialPageRoute(
        //                                         builder: (context) =>
        //                                             ObservationView(
        //                                                 observation: observation,
        //                                                 index: index)),
        //                                   ).then(onGoBack);
        //                                 },
        //                                 child: Container(
        //                                   padding: const EdgeInsets.only(
        //                                       left: 15,
        //                                       right: 15,
        //                                       top: 8,
        //                                       bottom: 8),
        //                                   decoration: BoxDecoration(
        //                                       borderRadius: BorderRadius.all(
        //                                           Radius.circular(8.0)),
        //                                       border:
        //                                       Border.all(color: Colors.black)),
        //                                   child: Row(
        //                                     children: [
        //                                       SvgPicture.asset(
        //                                           "images/app/icons/viewN.svg"),
        //                                       SizedBox(width: 5),
        //                                       Text("View",
        //                                           style: TextStyle(
        //                                               color: Colors.black,
        //                                               fontSize: 12,
        //                                               fontFamily: 'Inter')),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                                 InkWell(
        //                                   onTap: () {Navigator.push(
        //                                     context,
        //                                     MaterialPageRoute(
        //                                         builder: (context) =>
        //                                             ObservationEdit(

        //                                             )),
        //                                   ).then(onGoBack);},
        //                                   child: Container(
        //                                     padding: const EdgeInsets.only(
        //                                         left: 15,
        //                                         right: 15,
        //                                         top: 0,
        //                                         bottom: 0),
        //                                     decoration: BoxDecoration(
        //                                         borderRadius: BorderRadius.all(
        //                                             Radius.circular(8.0)),
        //                                         border: Border.all(color: icon)),
        //                                     child: Row(
        //                                       children: [
        //                                         // Image.asset("images/app/icons/pencil.png", width: 15,),
        //                                         SvgPicture.asset(
        //                                             "images/app/icons/pencilN.svg"),
        //                                         SizedBox(width: 5),
        //                                         Text("Edit",
        //                                             style: TextStyle(
        //                                                 color: icon,
        //                                                 fontSize: 12,
        //                                                 fontFamily: 'Inter')),
        //                                       ],
        //                                     ),
        //                                   ),
        //                                 ),
        //                               InkWell(
        //                                 onTap: () {
        //                                   setState(() {
        //                                     /*observation.removeAt(index);*/
        //                                     showAlert(
        //                                         context,
        //                                         index,
        //                                         observation[index].recordNo,
        //                                         observation[index].id);
        //                                   });
        //                                 },
        //                                 child: Container(
        //                                   padding: const EdgeInsets.only(
        //                                       left: 15,
        //                                       right: 15,
        //                                       top: 8,
        //                                       bottom: 8),
        //                                   decoration: BoxDecoration(
        //                                       borderRadius: BorderRadius.all(
        //                                           Radius.circular(8.0)),
        //                                       border:
        //                                       Border.all(color: Colors.red)),
        //                                   child: Row(
        //                                     children: [
        //                                       SvgPicture.asset(
        //                                           "images/app/icons/deleteN.svg"),
        //                                       SizedBox(width: 5),
        //                                       Text("Delete",
        //                                           style: TextStyle(
        //                                               color: Colors.red,
        //                                               fontSize: 12,
        //                                               fontFamily: 'Inter')),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           );
        //         }),
        //   ),
        // );
        Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            'Observation List',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 27,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ObservationCreate()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF145d87),
              // Colors.white,
              Colors.white
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: observation.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ObservationView(
                          observation: observation,
                          index: index,
                        ),
                      ),
                    ).then(onGoBack);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "OBS No: ${observation[index].recordNo}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: getColor(
                                    observation[index].observationStage),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "Stage: ${observation[index].observationStage}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Observation Date: ${observation[index].observationDate.split("T")[0]}",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ObservationEdit(),
                                ),
                              ).then(onGoBack);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            label: Text(
                              'Edit',
                              style: TextStyle(color: Colors.blue),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(0, 30),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                showAlert(
                                  context,
                                  index,
                                  observation[index].recordNo,
                                  observation[index].id,
                                );
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            label: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(0, 30),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showAlert(BuildContext context, int index, var content, var id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(content,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: textSizeMedium,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600)),
          content: Text("Are you sure want to delete?",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: textSizeSMedium,
                  fontFamily: 'Inter')),
          actions: <Widget>[
            TextButton(
              child: Text("YES",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: textSizeSMedium,
                      fontFamily: 'Inter')),
              onPressed: () {
                setState(() {
                  observationDelete(id, index);
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: Text("NO",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: textSizeSMedium,
                      fontFamily: 'Inter')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  retrive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString(TOKEN);
    setState(() => token = _token!);
    print(token);
    getObservationList();
  }

  Color getColor(String stage) {
    if (stage.toLowerCase() == "draft") {
      return Colors.blue;
    } else if (stage.toLowerCase() == "review") {
      return Colors.blue;
    } else if (stage.toLowerCase() == "approved") {
      return Colors.blue;
    } else if (stage.toLowerCase() == "closed") {
      return Colors.green;
    } else if (stage.toLowerCase() == "cancelled") {
      return Colors.red;
    } else {
      return Colors.deepOrangeAccent;
    }
  }
}
