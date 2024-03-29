import 'dart:convert';

import 'package:ehs_new/Model/CommentsModel.dart';
import 'package:ehs_new/utils/AppConstant.dart';
import 'package:ehs_new/utils/String.dart';
import 'package:ehs_new/utils/color.dart';
import 'package:ehs_new/widget/AppWidget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Model/AttachmentsModel.dart';
import '../../Model/InspectionsModel.dart';

// ignore: must_be_immutable
class InspectionView extends StatefulWidget {
  static String tag = '/InspectionsView';
  final List<InspectionsModel> inspection;
  var index;
  InspectionView({required this.inspection, this.index});

  @override
  InspectionViewState createState() =>  InspectionViewState();

}

class  InspectionViewState extends State< InspectionView> {
  List<CommentsModel> comments = [];
  late String token;
  var recordNo, mb;
  List<AttachmentsModel> attachments = [];
  ExpandableController categoryController = ExpandableController(initialExpanded: true);

  @override
  void initState() {
    super.initState();
    retrive();
  }

  retrive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString(TOKEN);
    setState(() => token = _token!);
    print(token);
    setState(() {
      recordNo =  widget.inspection[widget.index].recordNo;
      getCommentsList("INSPECTIONMANAGEMENT", recordNo);
    });
  }

  Map<String, String> get headers => {
    "Authorization": 'bearer ' + token,
  };

  Future<void> getCommentsList(var objectTypeId, var taskCommentObjectId) async {
    showLoaderDialog(context);
    String Url = getObsvComments + "?TaskCommentObjectTypeId=" + objectTypeId + "&TaskCommentObjectId=" + taskCommentObjectId;
    final Uri getObsComments = Uri.parse(Url);
    Response response =
    await get(getObsComments, headers: headers).timeout(
        Duration(seconds: timeOut));
    var getData;
    print(response.statusCode);
    /*comments.clear();*/
    if(response.body.isNotEmpty) {
      getData = json.decode(response.body);
      setState(() {
        var count = getData["items"].length;
        for (int i = 0; i < count; i++) {
          if(getData['items'][i]['taskComment']['taskCommentObjectTypeId'] == objectTypeId && getData['items'][i]['taskComment']['taskCommentObjectId'] == taskCommentObjectId){
            var commentsItems = getData['items'][i]['taskComment'];
            var commentItem = getData['items'][i];
            DateTime date = DateTime.parse(commentsItems['creationTime']);
            String formattedDate = DateFormat('yyyy-MM-dd HH:MM').format(date);
            print(formattedDate);
            CommentsModel commentsModel = new CommentsModel(
                commentsItems['taskCommentStage'],
                commentsItems['id'],
                commentsItems['taskCommentComments'],
                commentsItems['taskCommentEmployeeNumber'],
                commentsItems['taskCommentObjectId'],
                commentItem['taskCommentEmployeeDisplayName'],
                commentsItems['taskCommentObjectTypeId'],
                formattedDate);
            comments.add(commentsModel);
          }

        }
      });
    }
    Navigator.pop(context);
    getAttachment();
  }

  Future<void> getAttachment() async {
    showLoaderDialog(context);
    String Url = getAtt + "ObjectTypeId=AUDITMANAGEMENT"+ "&objectId=" + recordNo + "&customField1=" + recordNo;
    final Uri getAudAttachment = Uri.parse(Url);
    Response response =
    await get(getAudAttachment, headers: headers).timeout(
        Duration(seconds: timeOut));
    if(response.body.isNotEmpty) {
      var getData = json.decode(response.body);
      print(getData);
      var count = getData["items"].length;
      for (int i = 0; i < count; i++) {
        var attachmentsItems = getData['items'][i]['attachment'];
        // print(attachmentsItems['objectTypeId']);
        print(attachmentsItems);
        print(recordNo);
        mb = attachmentsItems['fileContentLength'] / 1024;
        mb = double.parse(mb.toStringAsFixed(2));
        AttachmentsModel attachmentsModel = new AttachmentsModel(attachmentsItems['objectId'], attachmentsItems['fileName'], attachmentsItems['fileExtension'], mb!);
        setState(() {
          attachments.add(attachmentsModel);
        });
      }

    }
    print("attachments");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: bg,
        title: Text("Inspections Details", style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Colors.black, fontSize: textSizeMedium),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                      ),
                    ),
                    ExpandablePanel(
                        controller: categoryController,
                        theme: ExpandableThemeData(iconColor: headerColor, iconSize: 40),
                        header: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                          child: Text("Inspection Management", softWrap: true, style: TextStyle(fontSize:16, color: headerColor, fontWeight: FontWeight.normal)),
                        ),
                        expanded: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Stage :", softWrap: true, style: TextStyle(fontSize:15, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Inter')),
                                    Text(widget.inspection[widget.index].stage, softWrap: true, style: TextStyle(fontSize:17, color: textColor, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Task Schedule Id :", softWrap: true, style: TextStyle(fontSize:15, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Inter')),
                                    Text(widget.inspection[widget.index].taskScheduleId, softWrap: true, style: TextStyle(fontSize:17, color: textColor, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Record No :", softWrap: true, style: TextStyle(fontSize:15, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Inter')),
                                    Text(widget.inspection[widget.index].recordNo, softWrap: true, style: TextStyle(fontSize:17, color: textColor, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Organization :", softWrap: true, style: TextStyle(fontSize:15, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Inter')),
                                    Text(widget.inspection[widget.index].inspectionManagementOrganizationDisplayName, softWrap: true, style: TextStyle(fontSize:17, color: textColor, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Inspections Type :", softWrap: true, style: TextStyle(fontSize:15, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Inter')),
                                    Text(widget.inspection[widget.index].inspectionManagementInspectionsTypeDisplayName, softWrap: true, style: TextStyle(fontSize:17, color: textColor, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Inspector :", softWrap: true, style: TextStyle(fontSize:15, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Inter')),
                                    Text(widget.inspection[widget.index].inspectionManagementInspectorDisplayName, softWrap: true, style: TextStyle(fontSize:17, color: textColor, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Scheduled Date :", softWrap: true, style: TextStyle(fontSize:15, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Inter')),
                                    Text(widget.inspection[widget.index].scheduledDate.split('T')[0], softWrap: true, style: TextStyle(fontSize:17, color: textColor, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Date of Inspection", softWrap: true, style: TextStyle(fontSize:15, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Inter')),
                                    Text(widget.inspection[widget.index].date.split('T')[0], softWrap: true, style: TextStyle(fontSize:17, color: textColor, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      collapsed:  Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text("",textAlign: TextAlign.center),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                      ),
                    ),
                    ExpandablePanel(
                      theme: ExpandableThemeData(iconColor: headerColor, iconSize: 40),
                      header: Container(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                        child: Text("Attachments", softWrap: true, style: TextStyle(fontSize:16, color: headerColor, fontWeight: FontWeight.normal)),
                      ),
                      expanded: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(top:15, left: 0, right: 0),
                              margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
                              /*decoration: _boxDecoration(),*/
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 20,
                                  columns: [
                                    DataColumn(label: Container( width: 90, child: Text("Record No.", softWrap: true, style: TextStyle()),)),
                                    DataColumn(label: Container( width: 90, child: Text("File Name", softWrap: true, style: TextStyle()),)),
                                    DataColumn(label: Container( width: 70, child: Text("File Extension", softWrap: true, style: TextStyle()),)),
                                    DataColumn(label: Container( width: 80, child: Text("File Size", softWrap: true, style: TextStyle()),)),
                                  ],
                                  rows: attachments.map((e) => DataRow(
                                      cells: [DataCell(
                                          Container(
                                              padding: const EdgeInsets.only(right: 0),
                                              width: 100, //SET width
                                              child: Text(e.recordNo, style: TextStyle(fontFamily: 'Inter'),))),
                                        DataCell(
                                            Container(
                                                width: 100, //SET width
                                                child: Text(e.fileName, style: TextStyle(fontFamily: 'Inter')))),
                                        DataCell(
                                            Container(
                                                width: 50, //SET width
                                                child: Text(e.fileExtension, style: TextStyle(fontFamily: 'Inter')))),
                                        DataCell(
                                            Container(
                                                width: 100, //SET width
                                                child: Text(e.fileSize.toString(), style: TextStyle(fontFamily: 'Inter')))),
                                      ]),).toList(),
                                ),
                              ),
                            ),
                          ]
                      ),
                      collapsed:  Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text("",textAlign: TextAlign.center),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                      ),
                    ),
                    ExpandablePanel(
                      theme: ExpandableThemeData(iconColor: headerColor, iconSize: 40),
                      header: Container(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                        child: Text("Comments", softWrap: true, style: TextStyle(fontSize:16, color: headerColor, fontWeight: FontWeight.normal)),
                      ),
                      expanded: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(top:15, left: 0, right: 0),
                              margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
                              /*decoration: _boxDecoration(),*/
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 20,
                                  columns: [
                                    DataColumn(label: Container( width: 90, child: Text("Date", softWrap: true, style: TextStyle()),)),
                                    DataColumn(label: Container( width: 90, child: Text("Stage", softWrap: true, style: TextStyle()),)),
                                    DataColumn(label: Container( width: 80, child: Text("Comments", softWrap: true, style: TextStyle()),)),
                                    DataColumn(label: Container( width: 70, child: Text("Employee", softWrap: true, style: TextStyle()),)),
                                  ],

                                  rows: comments.map((e) => DataRow(
                                      cells: [DataCell(
                                          Container(
                                              padding: const EdgeInsets.only(right: 0),
                                              width: 70, //SET width
                                              child: Text(e.creationTime, style: TextStyle(fontFamily: 'Inter'),))),
                                        DataCell(
                                            Container(
                                                width: 50, //SET width
                                                child: Text(e.taskCommentStage, style: TextStyle(fontFamily: 'Inter')))),
                                        DataCell(
                                            Container(
                                                width: 50, //SET width
                                                child: Text(e.taskCommentComments, style: TextStyle(fontFamily: 'Inter')))),
                                        DataCell(
                                            Container(
                                                width: 70, //SET width
                                                child: Text(e.taskCommentEmployeeDisplayName, style: TextStyle(fontFamily: 'Inter')))),
                                      ]),).toList(),
                                ),
                              ),
                            ),
                          ]
                      ),
                      collapsed:  Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text("",textAlign: TextAlign.center),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                      ),
                    ),
                    ExpandablePanel(
                        theme: ExpandableThemeData(iconColor: headerColor, iconSize: 40),
                        header: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                          child: Text("In-Progress", softWrap: true, style: TextStyle(fontSize:16, color: headerColor, fontWeight: FontWeight.normal)),
                        ),
                        expanded: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                            ]
                        ),
                      collapsed:  Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text("",textAlign: TextAlign.center),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                      ),
                    ),
                    ExpandablePanel(
                        theme: ExpandableThemeData(iconColor: headerColor, iconSize: 40),
                        header: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                          child: Text("Actions", softWrap: true, style: TextStyle(fontSize:16, color: headerColor, fontWeight: FontWeight.normal)),
                        ),
                        expanded: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(top:15, left: 0, right: 0),
                                margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
                                /*decoration: _boxDecoration(),*/
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                      columnSpacing: 20,
                                      columns: [
                                        DataColumn(label: Container( width: 90, child: Text("Actions", softWrap: true, style: TextStyle(fontFamily: 'Inter')),)),
                                        DataColumn(label: Container( width: 90, child: Text("Taks No", softWrap: true, style: TextStyle(fontFamily: 'Inter')),)),
                                        DataColumn(label: Container( width: 70, child: Text("Organization", softWrap: true, style: TextStyle(fontFamily: 'Inter')),)),
                                        DataColumn(label: Container( width: 80, child: Text("Reference No", softWrap: true, style: TextStyle(fontFamily: 'Inter')),)),
                                        DataColumn(label: Container( width: 90, child: Text("Priority", softWrap: true, style: TextStyle(fontFamily: 'Inter')),)),
                                        DataColumn(label: Container( width: 90, child: Text("Target Date", softWrap: true, style: TextStyle(fontFamily: 'Inter')),)),
                                        DataColumn(label: Container( width: 70, child: Text("Stage", softWrap: true, style: TextStyle(fontFamily: 'Inter')),)),
                                      ],
                                      rows: []
                                  ),
                                ),
                              ),
                            ]
                        ),
                      collapsed:  Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text("",textAlign: TextAlign.center),
                      ),
                    )
                  ],
                ),
              ),
            ],

        ),
        ),
      ),
    );
  }
  
}