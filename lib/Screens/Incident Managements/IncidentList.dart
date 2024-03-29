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

import '../../Model/IncidentModel.dart';
import 'IncidentEdit.dart';
import 'IncidentView.dart';

class IncidentList extends StatefulWidget {
  static String tag = '/Incident';

  @override
  IncidentListState createState() => IncidentListState();
}

class IncidentListState extends State<IncidentList> {
  late String token;
  List<IncidentModel> incident = [];
  var getData;
  late SharedPreferences prefs;
  var passData;

  @override
  void initState() {
    super.initState();
    retrive();
  }

  Map<String, String> get headers => {
        "Authorization": 'bearer ' + token,
      };

  Future<void> getIncidentList() async {
    showLoaderDialog(context);
    Response response = await get(getIncident, headers: headers)
        .timeout(Duration(seconds: timeOut));
    getData = json.decode(response.body);
    incident.clear();
    setState(() {
      var count = getData["items"].length;
      for (int i = 0; i < count; i++) {
        var incidentItems = getData["items"][i];
        IncidentModel incidentModel = IncidentModel(
            incidentItems['incidentManagement']['id'] != null ? incidentItems['incidentManagement']['id'] : " ",
            incidentItems['incidentManagement']['stage'] != null ? incidentItems['incidentManagement']['stage'] : " ",
            incidentItems['incidentManagement']['status'] != null ? incidentItems['incidentManagement']['status']: " ",
            incidentItems['incidentManagement']['recordNo'] != null ? incidentItems['incidentManagement']['recordNo'] : " ",
            incidentItems['incidentManagement']['organizationUnitId'] != null
                ? incidentItems['incidentManagement']['organizationUnitId']
                : " ",
            incidentItems['incidentManagementOrganizationDisplayName'] != null
                ? incidentItems['incidentManagementOrganizationDisplayName']
                : " ",
            incidentItems['incidentManagement']['incidentTitle'] != null
                ? incidentItems['incidentManagement']['incidentTitle']
                : " ",
            incidentItems['incidentManagement']['dateOfIncident'] != null
                ? incidentItems['incidentManagement']['dateOfIncident']
                : " ",
            incidentItems['incidentManagement']['timeOfIncident'] != null
                ? incidentItems['incidentManagement']['timeOfIncident']
                : " ",
            incidentItems['incidentManagement']['eventType'] != null
                ? incidentItems['incidentManagement']['eventType']
                : " ",
            incidentItems['incidentManagementEventTypeDisplayName'] != null
                ? incidentItems['incidentManagementEventTypeDisplayName']
                : " ",
            incidentItems['incidentManagement']['workRelated'] != null
                ? incidentItems['incidentManagement']['workRelated']
                : " ",
            incidentItems['incidentManagementWorkRelatedDisplayName'] != null
                ? incidentItems['incidentManagementWorkRelatedDisplayName']
                : " ",
            incidentItems['incidentManagement']['supervisorOnDuty'] != null
                ? incidentItems['incidentManagement']['supervisorOnDuty']
                : " ",
            incidentItems['incidentManagementSupervisorOnDutyDisplayName'] != null
                ? incidentItems['incidentManagementSupervisorOnDutyDisplayName']
                : " ",
            incidentItems['incidentManagement']['incidentDescription'] != null
                ? incidentItems['incidentManagement']['incidentDescription']
                : " ",
            incidentItems['incidentManagement']['immediateCorrectiveActionTaken'] != null
                ? incidentItems['incidentManagement']['immediateCorrectiveActionTaken']
                : " ",
            incidentItems['incidentManagement']['reportedBy'] != null
                ? incidentItems['incidentManagement']['reportedBy']
                : " ",
            incidentItems['incidentManagementReportedByDisplayName'] != null
                ? incidentItems['incidentManagementReportedByDisplayName']
                : " ",
            incidentItems['otherReportedBy'] != null
                ? incidentItems['otherReportedBy']
                : " ",
            incidentItems['incidentManagement']['dateReported'] != null
                ? incidentItems['incidentManagement']['dateReported']
                : " "
        );
        incident.add(incidentModel);
      }
    });
      Navigator.pop(context);
  }

  Future<void> incidentDelete(String id, int index) async {
    showLoaderDialog(context);
    Response response = await delete(
            Uri.parse(
                baseUrlTenants + 'incident-service/incident-managements/' + id),
            headers: headers)
        .timeout(Duration(seconds: timeOut));
    print(response.statusCode);
    if (response.statusCode == 204) {
      setState(() {
        incident.removeAt(index);
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
      getIncidentList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('Incident List',
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
            itemCount: incident.length,
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
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text("Incident Number",
                                              style: TextStyle(
                                                  color: listHeadingColor,
                                                  fontSize: 14,
                                                  fontFamily: 'Inter'),
                                              textAlign: TextAlign.left),
                                        ),
                                        Container(
                                          child: Text(incident[index].recordNo,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.left),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          child: Text(
                                            "Incident Title",
                                            style: TextStyle(
                                                color: listHeadingColor,
                                                fontSize: 14,
                                                fontFamily: 'Inter'),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            incident[index].incidentTitle,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          child: Text("Incident Date",
                                              style: TextStyle(
                                                  color: listHeadingColor,
                                                  fontSize: 14,
                                                  fontFamily: 'Inter'),
                                              textAlign: TextAlign.left),
                                        ),
                                        Container(
                                          child: Text(
                                              incident[index]
                                                  .dateOfIncident
                                                  .split("T")[0],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.left),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: boxDecoration(
                                        showShadow: false,
                                        bgColor:
                                            getColor(incident[index].stage),
                                        radius: 8),
                                    child: Text(
                                        "Stage : " + incident[index].stage,
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
                                            builder: (context) => IncidentView(
                                                incident: incident,
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
                                          var value =
                                              getData["items"][i]['incidentManagement']['recordNo'];
                                          if (value ==
                                              incident[index].recordNo) {
                                            passData = getData["items"][i]['incidentManagement'];
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      IncidentEdit(
                                                        // data: passData,
                                                        // index: index,
                                                        // key: navigatorKey,
                                                      )),
                                            ).then(onGoBack);
                                            break;
                                          }else{
                                            print(value);
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 0,
                                            bottom: 0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            border: Border.all(color: Colors.black)),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                "images/app/icons/pencilN.svg"),
                                            SizedBox(width: 5),
                                            Text("Edit",
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
                                      setState(() {
                                        print(incident[index].id);
                                        showAlert(
                                            context,
                                            index,
                                            incident[index].recordNo,
                                            incident[index].id);
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
                setState(() {
                  incidentDelete(id, index);
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
    print("bjbjbjb     " + token);
    getIncidentList();
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
