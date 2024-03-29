import 'dart:async';
import 'dart:convert';

import 'package:ehs_new/utils/AppConstant.dart';
import 'package:ehs_new/utils/String.dart';
import 'package:ehs_new/utils/color.dart';
import 'package:ehs_new/widget/AppWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Model/InspectionsModel.dart';
import 'InspectionEdit.dart';
import 'InspectionView.dart';

class InspectionList extends StatefulWidget {
  static String tag = '/Inspection';

  @override
  InspectionListState createState() => InspectionListState();
}

class InspectionListState extends State<InspectionList> {
  late String token;
  List<InspectionsModel> inspection = [];
  var getData, passData;

  @override
  void initState() {
    super.initState();
    retrive();
  }

  Map<String, String> get headers => {
        "Authorization": 'bearer ' + token,
      };

  Future<void> getInspectionList() async {
    showLoaderDialog(context);
    Response response = await get(getInspections, headers: headers)
        .timeout(Duration(seconds: timeOut));
    print(response.body);
    getData = json.decode(response.body);
    // String error = getData["error"];
    // if(error != Error){
    /* var items = getData["items"];*/
    print(getData["items"].length);
    inspection.clear();
    setState(() {
      var count = getData["items"].length;
      for (int i = 0; i < count; i++) {
        var observationItems = getData["items"][i];
        print(observationItems);
        InspectionsModel inspectionsModel = InspectionsModel(
          observationItems['inspectionManagement']['stage'] != null
              ? observationItems['inspectionManagement']['stage']
              : " ",
          observationItems['inspectionManagement']['id'] != null
              ? observationItems['inspectionManagement']['id']
              : " ",
          observationItems['inspectionManagement']['taskScheduleId'] != null
              ? observationItems['inspectionManagement']['taskScheduleId']
              : " ",
          observationItems['inspectionManagement']['recordNo'] != null
              ? observationItems['inspectionManagement']['recordNo']
              : " ",
          observationItems['inspectionManagementOrganizationDisplayName'] != null
                ? observationItems['inspectionManagementOrganizationDisplayName']
                : " ",
          observationItems['inspectionManagementInspectionsTypeDisplayName'] != null
              ? observationItems['inspectionManagementInspectionsTypeDisplayName']
              : " ",
          observationItems['inspectionManagementInspectorDisplayName'] != null
                ? observationItems['inspectionManagementInspectorDisplayName']
                : " ",
          observationItems['inspectionManagement']['scheduledDate'] != null
              ? observationItems['inspectionManagement']['scheduledDate']
              : " ",
          observationItems['inspectionManagement']['date'] != null
                ? observationItems['inspectionManagement']['date']
                : " "
        );
        inspection.add(inspectionsModel);
      }
    });
   Navigator.pop(context);
  }

  Future<void> inspectionDelete(String id, int index) async {
    showLoaderDialog(context);
    Response response = await delete(
            Uri.parse(baseUrlTenants +
                'inspection-service/inspection-managements/' +
                id),
            headers: headers)
        .timeout(Duration(seconds: timeOut));
    print(response.statusCode);
    if (response.statusCode == 204) {
      setState(() {
        inspection.removeAt(index);
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
      getInspectionList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('Inspection Managements',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: textSizeMedium)),
        backgroundColor: bg,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: inspection.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: defaultBoxShadow(),
                    color: Colors.white),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text("Record Number",
                                            style: TextStyle(
                                                color: listHeadingColor,
                                                fontSize: 14,
                                                fontFamily: 'Inter'),
                                            textAlign: TextAlign.left),
                                      ),
                                      Container(
                                        child: Text(inspection[index].recordNo,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.left),
                                      ),
                                      SizedBox(height: 4),
                                      Container(
                                        child: Text("Scheduled Date",
                                            style: TextStyle(
                                                color: listHeadingColor,
                                                fontSize: 14,
                                                fontFamily: 'Inter'),
                                            textAlign: TextAlign.left),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Text(
                                            inspection[index]
                                                .scheduledDate
                                                .split("T")[0],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w600),
                                            maxLines: 2),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: boxDecoration(
                                        showShadow: false,
                                        bgColor:
                                            getColor(inspection[index].stage),
                                        radius: 8),
                                    child: Text(
                                        "Stage : " + inspection[index].stage,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'Inter'),
                                        textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InspectionView(
                                                    inspection: inspection,
                                                    index: index)),
                                      ).then(onGoBack);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 8,
                                          bottom: 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "images/app/icons/viewN.svg"),
                                          SizedBox(width: 5),
                                          Text("View",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily: 'Inter')),
                                        ],
                                      ),
                                    ),
                                  ),
                                    InkWell(
                                      onTap: () {
                                        for (int i = 0;
                                        i < getData["items"].length;
                                        i++) {
                                          var value = getData["items"][i]
                                          ['inspectionManagement']['recordNo'];
                                          if (value == inspection[index].recordNo) {
                                            passData = getData["items"][i]
                                            ['inspectionManagement'];
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InspectionEdit(
                                                        // data: passData,
                                                        // index: index,
                                                        // key: navigatorKey,
                                                      )),
                                            ).then(onGoBack);
                                            break;
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 7,
                                            bottom: 7),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            border: Border.all(color: icon)),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset("images/app/icons/pencilN.svg",
                                              width: 1,
                                              height: 19,),
                                            SizedBox(width: 7),
                                            Text("Edit",
                                                style: TextStyle(
                                                    color: icon,
                                                    fontSize: 13,
                                                    fontFamily: 'Inter')),
                                          ],
                                        ),
                                      ),
                                    ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showAlert(
                                            context,
                                            index,
                                            inspection[index].recordNo,
                                            inspection[index].id);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 8,
                                          bottom: 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          border:
                                              Border.all(color: Colors.red)),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "images/app/icons/deleteN.svg"),
                                          SizedBox(width: 5),
                                          Text("Delete",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                  fontFamily: 'Inter')),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
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
                  color: Colors.red,
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
                //Put your code here which you want to execute on Yes button click.
                setState(() {
                  inspectionDelete(id, index);
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
                //Put your code here which you want to execute on No button click.
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
    getInspectionList();
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
