import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../Utils/AppConstant.dart';
import '../../Utils/color.dart';

class OfflineObservationView extends StatefulWidget {
  final Map<String, dynamic> map;

  const OfflineObservationView({super.key, required this.map});

  @override
  State<OfflineObservationView> createState() => _OfflineObservationViewState();
}

class _OfflineObservationViewState extends State<OfflineObservationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: bg,
          title: Text(
            "Observation Details",
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: textSizeMedium),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Scaffold(
            body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                      ),
                      ExpandablePanel(
                        // controller: categoryController,
                        theme: ExpandableThemeData(
                            iconColor: headerColor, iconSize: 40),
                        header: Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20),
                          child: Text("Observation",
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: headerColor,
                                  fontWeight: FontWeight.normal)),
                        ),
                        expanded: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Stage : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text('',
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: headerColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Record No : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text("OBS No: OBSV_03-2024-991",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Organization :",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text("Exceego",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Exact Location : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text(widget.map['ExactLocation'],
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Observation Date : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text(widget.map['ObservationDate'],
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Time : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text("11:48 AM",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Observation Type : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text(
                                        widget.map["checkOption"] == 1
                                            ? "Safe Act & SafeCondition"
                                            : widget.map["checkOption"] == 2
                                                ? "Unsafe Act"
                                                : "Unsafe Condition",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Detailed Description : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text(widget.map["Description"],
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Severity : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text("",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Immediate actions taken : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text("",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Comments : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text(widget.map['Description'],
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Date Repoerted : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text(widget.map['ReportedDate'],
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Reporting By : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text(widget.map['ReportedBy'],
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ]),
                        collapsed: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text("", textAlign: TextAlign.center),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                      ),
                      ExpandablePanel(
                        theme: ExpandableThemeData(
                            iconColor: headerColor, iconSize: 40),
                        header: Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20),
                          child: Text("Observation Details",
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: headerColor,
                                  fontWeight: FontWeight.normal)),
                        ),
                        expanded: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Unsafe act type : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text("",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Reaction of people : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text("",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Personal Protective Equipment : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text("",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ]),
                        collapsed: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text("", textAlign: TextAlign.center),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                      ),
                      ExpandablePanel(
                        theme: ExpandableThemeData(
                            iconColor: headerColor, iconSize: 40),
                        header: Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20),
                          child: Text("Reviewer's Section",
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: headerColor,
                                  fontWeight: FontWeight.normal)),
                        ),
                        expanded: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("HSE reviewer comments : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text(widget.map['comments'],
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Date reviewed : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text(widget.map["ReportedDate"],
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Reviewed By : ",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter')),
                                    Text(widget.map['ReportedBy'],
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ]),
                        collapsed: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text("", textAlign: TextAlign.center),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                      ),
                      ExpandablePanel(
                        theme: ExpandableThemeData(
                            iconColor: headerColor, iconSize: 40),
                        header: Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20),
                          child: Text("Actions",
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: headerColor,
                                  fontWeight: FontWeight.normal)),
                        ),
                        expanded: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 0, right: 0),
                                margin: const EdgeInsets.only(
                                    left: 0, right: 0, top: 5),
                                /*decoration: _boxDecoration(),*/
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(columnSpacing: 20, columns: [
                                    DataColumn(
                                        label: Container(
                                      width: 90,
                                      child: Text("Employee No.",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontFamily: 'RocgroTesk')),
                                    )),
                                    DataColumn(
                                        label: Container(
                                      width: 90,
                                      child: Text("Full Name",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontFamily: 'RocgroTesk')),
                                    )),
                                    DataColumn(
                                        label: Container(
                                      width: 70,
                                      child: Text("Email Id",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontFamily: 'RocgroTesk')),
                                    )),
                                    DataColumn(
                                        label: Container(
                                      width: 80,
                                      child: Text("Organization",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontFamily: 'RocgroTesk')),
                                    )),
                                  ], rows: []),
                                ),
                              ),
                            ]),
                        collapsed: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text("", textAlign: TextAlign.center),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                      ),
                    ],
                  ),
                ),
              ]),
        )));
  }
}
