import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ehs_new/Model/AttachmentsModel.dart';
import 'package:ehs_new/Model/AuditTypeModel.dart';
import 'package:ehs_new/Model/EmployeeModel.dart';
import 'package:ehs_new/Model/SubCommonModel.dart';
import 'package:ehs_new/Model/TanentsModel.dart';
import 'package:ehs_new/controller/observationController.dart';
import 'package:ehs_new/utils/AppConstant.dart';
import 'package:ehs_new/utils/String.dart';
import 'package:ehs_new/utils/color.dart';
import 'package:ehs_new/widget/AppWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:google_maps_webservice/places.dart';

import 'ObservationList.dart';

class ObservationCreate extends StatefulWidget {
  static String tag = '/ObservationEdit';
  String? _selectedValue;

  @override
  ObservationCreateState createState() => ObservationCreateState();
}

class ObservationCreateState extends State<ObservationCreate> {
  bool isYesClicked = false;
  ObservationController observationController =
      Get.put(ObservationController());
  List<String> allCountryNames = [];
  Map<String, TextEditingController> controllersMap = {};
  Map<String, dynamic> dropDownMap = {};
  var box = Hive.box('myBox');
  PageController pageController = PageController(initialPage: 0);
  List<AttachmentsModel> attachments = [];
  List<Map<String, dynamic>> dropdownItems = [];
  int pageNumber = 0;
  Logger logger = Logger();
  late String token;
  late File galleryFile;
  final picker = ImagePicker();
  List<EmployeeModel> employee = [];
  List<String> offlineEmployeeList = [];
  List<SubCommonModel> subCommon = [];
  List<TanentsModel> organizations = [];
  List<dynamic> _unSafeActSelected = [];
  List<dynamic> _unSafeActSubSelected = [];
  List<AuditTypeModel> auditTypes = [];
  bool reportingByActive = false,
      organizationActive = false,
      leadAuthority = false,
      facilityManager = false,
      auditType = false,
      propertyData = false,
      masterData = false,
      organizationData = false,
      memberData = false,
      observationDetails = false,
      observationSubDetails = false;
  var recordNo,
      datas,
      organizationSelection,
      dateOfAudits,
      timeOfAudits,
      leadAuthoritySelected,
      facilityManageSelected,
      auditTypeSelected,
      fileSelected,
      getPropertyData,
      getPropertyDataLength,
      positionSelection,
      radioSelected,
      extension = " ",
      base64,
      mb;
  List<int> _display = [];
  List<TextEditingController> controllers = [];
  List<Widget> _Widget = [];
  List<Widget> _WidgetObservationDetails = [];
  List<Widget> _WidgetObservationSubDetails = [];
  List<String> selectedUnsafeActs = [];
  List<String> selectedUnsafeConditions = [];
  List<List<String>> selectedUnsafeActOptions = [];
  List<List<String>> selectedUnsafeConditionOptions = [];
  int number = 1;
  var latlang;
  List<Widget> buildDotIndicator() {
    List<Widget> list = [];
    for (int i = 0; i <= 2; i++) {
      list.add(i == pageNumber
          ? indicator(isActive: true)
          : indicator(isActive: false));
    }
    return list;
  }

  final optionToListMap = {
    'Tools and Equipment': [
      'Used Incorrectly',
      'Wrong For The Job',
      'In Unsafe Condition',
    ],
    'Reaction of People': [
      'Stopping Job',
      'Adjusting Personal Protective Equipment',
      'Changing Position',
      'Rearranging Job',
      'Performing Lockouts',
      'Attaching Ground',
    ],
    'Procedures Orderliness/HouseKeeping': [
      'Procedures Inadequate',
      'Procedures Not Known/Understood',
      'Procedures Not Followed Orderliness Standard Inadequate',
      'Orderliness Standard Not Followed',
      'Orderliness Standard Not Known/Understood',
    ],
    'PPE': [
      'Trunk',
      'Ears',
      'Eyes and Face',
      'Arms and Hands',
      'Respiratory System',
      'Head',
      'Legs and Feet',
    ],
    'Vehicle/Traffic Related': [
      'Driving Without Seatbelt',
      'Other Traffic Violation',
      'Using GSM while Driving',
      'Over Speeding',
    ],
    'Position of People': [
      'Striking Against Objects',
      'Swallowing a Hazardous Substance',
      'Inhaling',
      'Caught in',
      'Overexertion Repetitive Motions',
      'Struck by Objects',
      'On or Between Objects',
      'Falling/SlipsTrips',
      'Contacting Temperature Extreme',
      'Absorbing',
      'Awkward Position/Static Postures',
      'Contacting Electrical Current',
      'Mobiletest',
    ],
  };

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
          final bytes = File(pickedFile.path).readAsBytesSync();
          base64 = base64Encode(bytes);
          print(base64);
          print(galleryFile.path);
          fileSelected = galleryFile.path.split('/').last;
          extension = fileSelected.split('.').last;
          final bytesinSize =
              File(pickedFile.path).readAsBytesSync().lengthInBytes;
          final kb = bytesinSize / 1024;
          mb = kb / 1024;
          print(extension);
          print(mb);
          postAttachments();
        } else {}
      },
    );
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        contentType: ContentType.failure,
        message: '',
      ),
    ));
  }

  Map<String, String> get headers =>
      {"Authorization": 'bearer ' + token, "Content-Type": 'application/json'};

  Map<String, String> get header => {"Content-Type": 'application/json'};

  Future<void> getMemberList() async {
    Response response = await get(getMember, headers: headers)
        .timeout(Duration(seconds: timeOut));
    var getData;
    if (response.body.isNotEmpty) {
      getData = json.decode(response.body);
    }
    employee.clear();
    setState(() {
      var count = getData["items"].length;
      for (int i = 0; i < count; i++) {
        var memberItems = getData['items'][i]['employee'];
        var memberItem = getData['items'][i];
        EmployeeModel employeeModel = new EmployeeModel(
            memberItems['employeeDisplayName'],
            memberItems['id'],
            memberItems['employeeNumber'],
            memberItems['employeeEmail'],
            memberItem['employeePositionDescription'] != null
                ? memberItem['employeePositionDescription']
                : " ",
            memberItem['organizationDisplayName'] != null
                ? memberItem['organizationDisplayName']
                : " ");
        employee.add(employeeModel);
      }
      memberData = true;
      if (memberData) {
        getOrganizationDatas();
        print("member");
      }
    });
  }

  Future<void> getOrganizationDatas() async {
    var itemsnull;
    Response response = await get(getOrganization, headers: headers)
        .timeout(Duration(seconds: timeOut));
    var getData = json.decode(response.body);
    var count = getData["items"].length;
    for (int i = 0; i < count; i++) {
      var organizationItems = getData['items'][i];
      if (organizationItems['parentId'] == null) {
        itemsnull = " ";
      } else {
        itemsnull = organizationItems['id'];
      }
      TanentsModel organizationModel = new TanentsModel(
          organizationItems['displayName'],
          organizationItems == null ? " " : organizationItems['id']);
      setState(() {
        organizations.add(organizationModel);
      });
    }

    final Map<String, dynamic> data = json.decode(response.body);

    final List<Map<String, dynamic>> nestedDropdownData =
        buildNestedDropdown(data['items']);

    setState(() {
      dropdownItems = nestedDropdownData;
    });

    setState(() {
      organizationActive = true;
      organizationData = true;
      print("org");
      getProperty();
    });
  }

  Future<void> getMasterDatas() async {
    Response response = await get(getMasterData, headers: headers)
        .timeout(Duration(seconds: timeOut));
    if (response.body.isNotEmpty) {
      datas = json.decode(response.body);
    }
    var count = datas["items"].length;
    subCommon.clear();
    for (int i = 0; i < count; i++) {
      var masterData = datas['items'][i]['masterData'];
      var masterDataObject = datas['items'][i]['masterDataObject'];
      SubCommonModel subCommonModel = new SubCommonModel(
          masterData['value'],
          masterData['masterDataObjectId'],
          masterDataObject == null
              ? " "
              : masterDataObject['masterDataObjectValue'],
          masterData['showControlIDs'] == null
              ? " "
              : masterData['showControlIDs'],
          masterData['id'] == null ? " " : masterData['id']);
      setState(() {
        subCommon.add(subCommonModel);
        print(subCommon[i].id);
      });
    }
    setState(() {
      masterData = true;
      if (masterData) {
        getMemberList();
        print("master");
      }
    });
  }

  Future<void> getMasterDrop(var code) async {
    _Widget.add(masterDropDownBox(code));
  }

  Future<void> getMasterRadio(var code) async {
    print(code);
    _Widget.add(radioitem(context, code));
  }

  Future<void> getObsProperty() async {
    showLoaderDialog(context);
    var items;
    String url =
        "https://webgateway.dev-ehswatch.com/api/observations-service/propertysettings/GetListPropertyAsync?Authorization=bearer {{AuthorizationToken}}&Content-Type=application/json&providerName=Observation&maxResultCount=1000";

    print(url);
    final Uri getObsPropertyData = Uri.parse(url);
    Response response = await get(getObsPropertyData, headers: headers)
        .timeout(Duration(seconds: timeOut));
    print(response.body);
    getPropertyData = json.decode(response.body);
    getPropertyDataLength = getPropertyData["items"].length;
    for (int i = 0; i < getPropertyDataLength; i++) {
      if (getPropertyData['items'][i]['providerName'] == "Observation" &&
          getPropertyData['items'][i]['visible'] &&
          getPropertyData['items'][i]['defaultDisplay'] &&
          getPropertyData['items'][i]['psDisplaySection'] == "Draft") {
        items = getPropertyData['items'][i];
        print(items["controlType"] +
            "   " +
            items["name"] +
            " " +
            items["displayOrderInView"].toString());
        _display.add(items["displayOrderInView"]);
        _display.sort();
      }
    }
    setState(() {
      propertyData = true;
      if (propertyData) {
        getMasterDatas();
        print("property");
      }
    });
  }

  Future<void> getProperty() async {
    print("sdasdasd");
    for (int i = 0; i < _display.length; i++) {
      for (int j = 0; j < getPropertyDataLength; j++) {
        if (getPropertyData['items'][j]['providerName'] == "Observation" &&
            getPropertyData['items'][j]['visible'] &&
            getPropertyData['items'][j]['defaultDisplay'] &&
            getPropertyData['items'][j]['psDisplaySection'] == "Draft") {
          var ite = getPropertyData['items'][j];
          if (_display[i].toString() == ite["displayOrderInView"].toString()) {
            print(ite['controlType']);
            switch (ite['controlType']) {
              case "TEXTBOX":
                TextEditingController controller = TextEditingController();
                controllers.add(controller);
                String value = ite['name'].toString().split("Observation.")[1];
                value = "${value[0].toLowerCase()}${value.substring(1)}";
                print("TEXTBOX---------------  " + value);
                controllersMap[value] = controller;
                setState(() {
                  if (ite['masterDataObjectCode'] == "")
                    _Widget.add(dynamicText(
                        ite['name'].toString().split("Observation.")[1],
                        textColor: textColor));
                  if (ite['name'].toString().split("Observation.")[1] ==
                      "ObservationStage") {
                    controller.text = "Draft";
                    _Widget.add(dynamicTextbox(50, controller, false));
                  } else {
                    _Widget.add(dynamicTextbox(50, controller, true));
                  }
                });
                break;
              case "TEXTAREA":
                TextEditingController controller = TextEditingController();
                controllers.add(controller);
                String value = ite['name'].toString().split("Observation.")[1];
                value = "${value[0].toLowerCase()}${value.substring(1)}";
                print("TEXTBOX************* " + value);
                controllersMap[value] = controller;
                setState(() {
                  if (ite['masterDataObjectCode'] == "")
                    _Widget.add(dynamicText(
                        ite['name'].toString().split("Observation.")[1],
                        textColor: textColor));
                  _Widget.add(dynamicTextbox(50, controller, true));
                });

                break;

              case "ORGANIZATION":
                _Widget.add(organizationBox(
                    ite['name'].toString().split("Observation.")[1]));
                break;
              case "EMPLOYEESEARCH_DEFAUTCURRENTUSER":
                _Widget.add(masterEmployeeDropDownBox(
                    ite['name'].toString().split("Observation.")[1]));
                break;
              case "TIME-NOFUTUREDATEENTRY":
                TextEditingController controller = TextEditingController();
                controllers.add(controller);
                String value = ite['name'].toString().split("Observation.")[1];
                value = "${value[0].toLowerCase()}${value.substring(1)}";
                print("TEXTBOX*&*&*&*&*&*  " + value);
                controllersMap[value] = controller;
                _Widget.add(dynamicText(
                    ite['name'].toString().split("Observation.")[1],
                    textColor: textColor));
                _Widget.add(timePicker(
                    controller,
                    dynamicText(
                        ite['name'].toString().split("Observation.")[1])));
                break;
              case "DATE-NOFUTUREDATEENTRY":
                TextEditingController controller = TextEditingController();
                controllers.add(controller);
                String value = ite['name'].toString().split("Observation.")[1];
                value = "${value[0].toLowerCase()}${value.substring(1)}";
                print("TEXTBOX%^&^%#%^  " + value);
                controllersMap[value] = controller;
                _Widget.add(dynamicText(
                    ite['name'].toString().split("Observation.")[1],
                    textColor: textColor));
                _Widget.add(datePicker(
                    controller,
                    dynamicText(
                        ite['name'].toString().split("Observation.")[1])));
                break;
              case "MASTERDROPDOWN":
                var codeDropDown = ite['masterDataObjectCode'];
                getMasterDrop(codeDropDown);
                break;
              case "RADIOBUTTON":
                print(ite['masterDataObjectCode']);
                var codeRadio = ite['masterDataObjectCode'];
                getMasterRadio(codeRadio);
                break;
            }
          }
        }
      }
    }
    Navigator.pop(context);
  }

  Future<void> getPropertyHidder(var controlIds) async {
    print(controlIds);
    print(getPropertyDataLength);
    for (int j = 0; j < getPropertyDataLength; j++) {
      if (getPropertyData['items'][j]['providerName'] == "Observation" &&
          getPropertyData['items'][j]['visible'] &&
          getPropertyData['items'][j]['name'] == "Observation." + controlIds &&
          getPropertyData['items'][j]['psDisplaySection'] == "Draft") {
        var ite = getPropertyData['items'][j];
        print(ite['controlType']);
        switch (ite['controlType']) {
          case "TEXTAREA":
            TextEditingController controller = TextEditingController();
            controllers.add(controller);
            controllersMap[ite['name'].toString().split("Observation.")[1]] =
                controller;
            if (ite['name'].toString().split("Observation.")[1] == "Stage") {
              controller.text = "Draft";
            }
            setState(() {
              if (ite['masterDataObjectCode'] == "")
                _Widget.add(dynamicText(
                    ite['name'].toString().split("Observation.")[1],
                    textColor: textColor));
              _Widget.add(dynamicTextbox(50, controller, true));
            });
            break;
        }
      }
    }
  }

  Future<void> getPropertySubHidden(var controlIds) async {
    print(controlIds);
    print(getPropertyDataLength);
    for (int j = 0; j < getPropertyDataLength; j++) {
      if (getPropertyData['items'][j]['providerName'] == "Observation" &&
          getPropertyData['items'][j]['visible'] &&
          getPropertyData['items'][j]['name'] == "Observation." + controlIds &&
          getPropertyData['items'][j]['psDisplaySection'] == "Draft") {
        var ite = getPropertyData['items'][j];
        print(ite['controlType']);
        switch (ite['controlType']) {
          case "TEXTAREA":
            TextEditingController controller = TextEditingController();
            controllers.add(controller);
            controllersMap[ite['name'].toString().split("Observation.")[1]] =
                controller;
            if (ite['name'].toString().split("Observation.")[1] == "Stage") {
              controller.text = "Draft";
            }
            setState(() {
              if (ite['masterDataObjectCode'] == "")
                _WidgetObservationSubDetails.add(dynamicText(
                    ite['name'].toString().split("Observation.")[1],
                    textColor: textColor));
              _WidgetObservationSubDetails.add(
                  dynamicTextbox(50, controller, false));
            });
            break;
        }
      }
    }
  }

  Future<void> postAttachments() async {
    showLoaderDialog(context);
    final msg = jsonEncode({
      "objectId": "Temp_OBSV_mounica_" + recordNo,
      "fileName": fileSelected.split('.').first,
      "fileExtension": "." + extension,
      "recordType": null,
      "objectTypeId": "OBSV",
      "attachmentUrl": "string",
      "thumbnailUrl": "string",
      "organizationUnitId": positionSelection
    });
    Response response1 =
        await post(createAttachments, headers: headers, body: msg)
            .timeout(Duration(seconds: timeOut));
    print(response1.body);
    if (response1.statusCode == 200) {
      final base = jsonEncode({
        "content": base64,
        "name": "OBSV/OBSV_" + recordNo + "/" + fileSelected,
        "tempFilePath": "string",
        "thumbnailUrl": "string"
      });
      Response responseBase =
          await post(saveAttachments, headers: headers, body: base)
              .timeout(Duration(seconds: timeOut));
      print("OBSV/Temp_OBSV_mounica_" + recordNo + "/" + fileSelected);
      if (responseBase.statusCode == 200) {
        print(responseBase.statusCode);
        var data = json.decode(responseBase.body);
        AttachmentsModel attachmentsModel = new AttachmentsModel(
            recordNo,
            fileSelected.split('.').first,
            extension,
            double.parse(mb.toStringAsFixed(2)));
        setState(() {
          attachments.add(attachmentsModel);
        });
        print(data);
      } else {}
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    retrive();
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String tdata = DateFormat("HH-mm-ss").format(DateTime.now());
    recordNo = cdate + "T" + tdata;
  }

  retrive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString(TOKEN);
    setState(() => token = _token!);
    print(token);
    setState(() {
      getObsProperty();
    });
  }

  // Future<void> createObservation(final values, final dropDownValues) async {
  //   String data = values + "," + dropDownValues;
  //   print(data);
  //   final msg = jsonEncode({data});
  //
  //   Response response1 =
  //       await post(createObservations, headers: headers, body: msg)
  //           .timeout(Duration(seconds: timeOut));
  //   print(response1.body);
  //   if (response1.statusCode == 200) {}
  // }

  Future<void> createObservation(final values, final dropDownValues) async {
    String wereImmediate = observationController.immidiateActionController.text;
    String unsafeType = observationController.textToShort.value;
    String immediateActionsTaken = ''; // Initialize with an empty string
    String unsafeConditionOptions = '';

    if (isYesClicked) {
      immediateActionsTaken = '';
    }

    for (int index = 0; index < selectedUnsafeConditions.length; index++) {
      unsafeConditionOptions +=
          '${selectedUnsafeConditions[index]}: ${selectedUnsafeConditionOptions[index].join(', ')}${index < selectedUnsafeConditions.length - 1 ? '; ' : ''}';
    }

    final data = {
      'values': values,
      'dropDownValues': dropDownValues,
      'wereImmediate': wereImmediate,
      'unsafeType': unsafeType,
      'immediateActionsTaken': immediateActionsTaken,
      'unsafeConditionOptions': unsafeConditionOptions,
      'organizationUnitId': organizationSelection,
    };

    final msg = jsonEncode(data);

    Response response1 =
        await post(createObservations, headers: headers, body: msg)
            .timeout(Duration(seconds: timeOut));
    print(response1.body);
    if (response1.statusCode == 200) {
      var responseData = jsonDecode(response1.body);
      String recordId = responseData['id'];

      box.put('wereImmediate_$recordId', wereImmediate);
      box.put('unsafeType_$recordId', unsafeType);
      box.put('immediateActionsTaken_$recordId', immediateActionsTaken);
      box.put('unsafeConditionOptions_$recordId', unsafeConditionOptions);

      Get.toNamed(ObservationList.tag);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('Observation',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: textSizeMedium)),
        backgroundColor: bg,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        Container(
            height: double.infinity,
            color: bg,
            child: PageView(
                onPageChanged: (index) => setState(() {
                      pageNumber = index;
                    }),
                controller: pageController,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16, bottom: 80, right: 16, top: 30),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  left: 10, top: 15, bottom: 15, right: 10),
                              decoration: boxDecoration(
                                  showShadow: true,
                                  bgColor: headerColor,
                                  radius: 8,
                                  color: border),
                              child: Text(
                                "Observation",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            StatefulBuilder(
                              builder: (context, StateSetter setState) {
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    primary: false,
                                    addAutomaticKeepAlives: true,
                                    padding: EdgeInsets.only(
                                        top: 10, left: 15, right: 15),
                                    itemCount: _Widget.length,
                                    itemBuilder: (BuildContext context, index) {
                                      Widget widget = _Widget.elementAt(index);
                                      return widget;
                                    });
                              },
                            ),
                            Obx(() {
                              return observationController.clickType.value ==
                                          2 ||
                                      observationController.clickType.value == 3
                                  ? Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 20, 130, 0),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                          child: dynamicText(
                                            "Were Immediate Actions taken?",
                                            textColor: textColor,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 8),
                                        child: DropdownButtonFormField<String>(
                                          value: positionSelection,
                                          onChanged: (String? value) {
                                            setState(() {
                                              positionSelection = value!;
                                            });
                                            if (value == 'Yes') {
                                              isYesClicked = true;
                                            } else {
                                              isYesClicked = false;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(fontSize: 12),
                                            hintText: 'Select an option',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 12.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color:
                                                    headerColor, // Border color
                                                width: 1.0, // Border width
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: headerColor,
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                          items: <String>['Yes', 'No']
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      if (isYesClicked)
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 20, 130, 0),
                                              child: Text(
                                                'Immediate Actions Taken',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: headerColor,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 8),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Enter the text',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ])
                                  : SizedBox();
                            }),
                            Obx(() {
                              return (observationController.clickType.value ==
                                          2 ||
                                      observationController.clickType.value ==
                                          3)
                                  ? Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.025,
                                              child: dynamicText(
                                                observationController
                                                            .clickType.value ==
                                                        2
                                                    ? "Unsafe Act Type             "
                                                    : "Type of Unsafe Condition",
                                                textColor: textColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (observationController
                                                .clickType.value ==
                                            2)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 20),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: observationController
                                                  .unsafeActList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                String option =
                                                    observationController
                                                        .unsafeActList[index];
                                                return CheckboxListTile(
                                                  title: Text(option),
                                                  value: selectedUnsafeActs
                                                      .contains(option),
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      if (value!) {
                                                        selectedUnsafeActs
                                                            .add(option);
                                                        selectedUnsafeActOptions
                                                            .add([]);
                                                      } else {
                                                        selectedUnsafeActs
                                                            .remove(option);
                                                        selectedUnsafeActOptions
                                                            .removeLast();
                                                      }
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        if (selectedUnsafeActs.isNotEmpty)
                                          ...selectedUnsafeActs
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key;
                                            return Column(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (selectedUnsafeActs[
                                                            index] !=
                                                        "Others") // Render only if it's not the "Others" option
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: Text(
                                                          selectedUnsafeActs[
                                                              index],
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: headerColor,
                                                          ),
                                                        ),
                                                      ),
                                                    if (selectedUnsafeActs[
                                                            index] !=
                                                        "Others")
                                                      SizedBox(height: 8),
                                                    if (selectedUnsafeActs[
                                                            index] !=
                                                        "Others") // Render CheckboxListTile only if it's not the "Others" option
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      headerColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                  child: Wrap(
                                                                    spacing:
                                                                        8.0,
                                                                    children: selectedUnsafeActOptions[
                                                                            index]
                                                                        .map((String
                                                                            option) {
                                                                      return Chip(
                                                                        label: Text(
                                                                            option),
                                                                        onDeleted:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            selectedUnsafeActOptions[index].remove(option);
                                                                          });
                                                                        },
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  children: optionToListMap[selectedUnsafeActs[
                                                                              index]]
                                                                          ?.map((String
                                                                              value) {
                                                                        return CheckboxListTile(
                                                                          title:
                                                                              Text(value),
                                                                          value:
                                                                              selectedUnsafeActOptions[index].contains(value) ?? false,
                                                                          onChanged:
                                                                              (bool? checked) {
                                                                            setState(() {
                                                                              if (checked != null) {
                                                                                if (checked) {
                                                                                  selectedUnsafeActOptions[index].add(value);
                                                                                } else {
                                                                                  selectedUnsafeActOptions[index].remove(value);
                                                                                }
                                                                              }
                                                                            });
                                                                          },
                                                                        );
                                                                      }).toList() ??
                                                                      [],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    if (selectedUnsafeActs[
                                                            index] ==
                                                        "Others")
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Header for "Other Unsafe Act Options"
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              'Other Unsafe Act Options*',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color:
                                                                    headerColor,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextField(
                                                                onChanged:
                                                                    (newValue) {
                                                                  // Handle the onChanged event
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Enter other unsafe act options...',
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                headerColor),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                headerColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        if (observationController
                                                .clickType.value ==
                                            3)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 20),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: observationController
                                                  .unsafeConditionsList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return CheckboxListTile(
                                                  title: Text(observationController
                                                          .unsafeConditionsList[
                                                      index]),
                                                  value: selectedUnsafeConditions
                                                      .contains(
                                                          observationController
                                                                  .unsafeConditionsList[
                                                              index]),
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      if (value!) {
                                                        selectedUnsafeConditions.add(
                                                            observationController
                                                                    .unsafeConditionsList[
                                                                index]);
                                                        selectedUnsafeConditionOptions
                                                            .add([]);
                                                      } else {
                                                        selectedUnsafeConditions.remove(
                                                            observationController
                                                                    .unsafeConditionsList[
                                                                index]);
                                                        selectedUnsafeConditionOptions
                                                            .removeLast();
                                                      }
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        if (selectedUnsafeConditions.isNotEmpty)
                                          ...selectedUnsafeConditions
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key;
                                            return Column(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: Text(
                                                        selectedUnsafeConditions[
                                                            index],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: headerColor,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Existing container
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    headerColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                child: Wrap(
                                                                  spacing: 8.0,
                                                                  children: selectedUnsafeConditionOptions[
                                                                          index]
                                                                      .map((String
                                                                          option) {
                                                                    return Chip(
                                                                      label: Text(
                                                                          option),
                                                                      onDeleted:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          selectedUnsafeConditionOptions[index]
                                                                              .remove(option);
                                                                        });
                                                                      },
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                              Column(
                                                                children: selectedUnsafeConditions[
                                                                            index] ==
                                                                        'Vehicle Related Unsafe Condition'
                                                                    ? observationController
                                                                        .vehicleRelatedUnsafeConditionOptionsList
                                                                        .map((String
                                                                            value) {
                                                                        return CheckboxListTile(
                                                                          title:
                                                                              Text(value),
                                                                          value:
                                                                              selectedUnsafeConditionOptions[index].contains(value),
                                                                          onChanged:
                                                                              (bool? checked) {
                                                                            setState(() {
                                                                              if (checked != null) {
                                                                                if (checked) {
                                                                                  selectedUnsafeConditionOptions[index].add(value);
                                                                                } else {
                                                                                  selectedUnsafeConditionOptions[index].remove(value);
                                                                                }
                                                                              }
                                                                            });
                                                                          },
                                                                        );
                                                                      }).toList()
                                                                    : observationController
                                                                        .unsafeConditionOptionsList
                                                                        .map((String
                                                                            value) {
                                                                        return CheckboxListTile(
                                                                          title:
                                                                              Text(value),
                                                                          value:
                                                                              selectedUnsafeConditionOptions[index].contains(value),
                                                                          onChanged:
                                                                              (bool? checked) {
                                                                            setState(() {
                                                                              if (checked != null) {
                                                                                if (checked) {
                                                                                  selectedUnsafeConditionOptions[index].add(value);
                                                                                } else {
                                                                                  selectedUnsafeConditionOptions[index].remove(value);
                                                                                }
                                                                              }
                                                                            });
                                                                          },
                                                                        );
                                                                      }).toList(),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        if (selectedUnsafeConditionOptions[
                                                                index]
                                                            .contains("Others"))
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // Header for "Other Unsafe Conditions"
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  'Other Unsafe Conditions*',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color:
                                                                        headerColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  TextField(
                                                                    onChanged:
                                                                        (newValue) {},
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          'Enter other unsafe conditions...',
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                        borderSide:
                                                                            BorderSide(color: headerColor),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                        borderSide:
                                                                            BorderSide(color: headerColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                      ],
                                    )
                                  : SizedBox();
                            }),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10, right: 10),
                                decoration: boxDecoration(
                                    showShadow: true,
                                    bgColor: headerColor,
                                    radius: 8,
                                    color: border),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Attachments",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _showPicker(context: context);
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    )
                                  ],
                                )),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 0, right: 0),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, top: 5),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 20,
                                  columns: [
                                    DataColumn(
                                        label: Container(
                                      width: 90,
                                      child: Text("Record No.",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontFamily: 'RocgroTesk')),
                                    )),
                                    DataColumn(
                                        label: Container(
                                      width: 90,
                                      child: Text("File Name",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontFamily: 'RocgroTesk')),
                                    )),
                                    DataColumn(
                                        label: Container(
                                      width: 80,
                                      child: Text("File Extension",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontFamily: 'RocgroTesk')),
                                    )),
                                    DataColumn(
                                        label: Container(
                                      width: 90,
                                      child: Text("File Size",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontFamily: 'RocgroTesk')),
                                    )),
                                  ],
                                  rows: attachments
                                      .map(
                                        (e) => DataRow(cells: [
                                          DataCell(Container(
                                              padding: const EdgeInsets.only(
                                                  right: 0),
                                              width: 70, //SET width
                                              child: Text(
                                                e.recordNo,
                                                style: TextStyle(
                                                    fontFamily: 'Inter'),
                                              ))),
                                          DataCell(Container(
                                              width: 50, //SET width
                                              child: Text(e.fileName,
                                                  style: TextStyle(
                                                      fontFamily: 'Inter')))),
                                          DataCell(Container(
                                              width: 50, //SET width
                                              child: Text(e.fileExtension,
                                                  style: TextStyle(
                                                      fontFamily: 'Inter')))),
                                          DataCell(Container(
                                              width: 70, //SET width
                                              child: Text(e.fileSize.toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'Inter')))),
                                        ]),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  if (observationDetails)
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 16, bottom: 80, right: 16, top: 30),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (context, StateSetter setState) {
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      primary: false,
                                      addAutomaticKeepAlives: true,
                                      padding: EdgeInsets.only(top: 10),
                                      itemCount:
                                          _WidgetObservationDetails.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        Widget widget =
                                            _WidgetObservationDetails.elementAt(
                                                index);
                                        return widget;
                                      });
                                },
                              ),
                            ]),
                      ),
                    ),
                  if (observationSubDetails)
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 16, bottom: 80, right: 16, top: 30),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (context, StateSetter setState) {
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      primary: false,
                                      addAutomaticKeepAlives: true,
                                      padding: EdgeInsets.only(top: 10),
                                      itemCount:
                                          _WidgetObservationSubDetails.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        Widget widget =
                                            _WidgetObservationSubDetails
                                                .elementAt(index);
                                        return widget;
                                      });
                                },
                              ),
                            ]),
                      ),
                    ),
                ])),
        GestureDetector(
          onTap: () {
            final values = controllersMap.entries
                .toList()
                .map((e) => ' \"${e.key}\"  : \"${e.value.text}\" ')
                .join(',');
            print(values);
            final dropdown = dropDownMap.entries
                .toList()
                .map((e) => ' \"${e.key}\" : \"${e.value}\" ')
                .join(',');
            print(dropdown +
                "wereImmediate : ${observationController.immidiateActionController.text}" +
                "unsafeType : ${observationController.textToShort.value}");

            box.put('OrgUnitId', allCountryNames);
            employee.map((e) {
              offlineEmployeeList.add(e.name);
            }).toList();
            box.put('employeeList', offlineEmployeeList);
            logger.i(box.get('OrgUnitId'));
            logger.i(box.get('employeeList'));

            createObservation(values, dropdown);
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            width: size.width,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: headerColor, width: 2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "Submit",
                    style: primaryTextStyle(
                      size: 16,
                      color: headerColor,
                      fontFamily: 'RocgroTesk',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return;
    if (result.files.isEmpty) return;
    setState(() {
      final file = result.files.first;
      fileSelected = file as String;
    });
  }

  Widget masterEmployeeDropDownBox(var code) {
    _Widget.add(dynamicText(code, textColor: textColor));
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Container(
          margin: const EdgeInsets.only(top: 10, left: 0, right: 0),
          padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(color: dynamicTextBorderColor, width: 1),
              color: Colors.white),
          child: Column(
            children: <Widget>[
              new DropdownButton(
                isExpanded: true,
                iconEnabledColor: headerColor,
                iconDisabledColor: headerColor,
                iconSize: 40,
                dropdownColor: Colors.white,
                items: employee.map((e) {
                  return new DropdownMenuItem(
                    child: new Text(
                      e.employeeNumber + "  " + e.name,
                      style: TextStyle(color: headerColor, fontFamily: 'Inter'),
                    ),
                    value: e.employeeNumber,
                  );
                }).toList(),
                onChanged: (newvalue) {
                  setState(() {
                    String result =
                        "${code[0].toLowerCase()}${code.substring(1)}";
                    dropDownMap[result] = newvalue;
                    positionSelection = newvalue;
                    print(positionSelection);
                  });
                },
                value: positionSelection,
              )
            ],
          ));
    });
  }

  Widget radioitem(BuildContext context, var code) {
    var radiolist = subCommon
        .where((element) => element.masterDataObjectId == code)
        .toList();
    _Widget.add(
        dynamicText(radiolist[0].masterDataObjectValue, textColor: textColor));
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Column(
        children: radiolist
            .map((data) => RadioListTile(
                  title: Text(
                    "${data.value}",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: textSizeSMedium,
                        fontWeight: FontWeight.w500),
                  ),
                  value: data.id,
                  groupValue: radioSelected,
                  toggleable: true,
                  onChanged: (val) {
                    setState(() {
                      if (data.value == 'Safe Act & Safe Condition') {
                        observationController.clickType.value = 1;
                      } else if (data.value == 'Unsafe Act') {
                        observationController.clickType.value = 2;
                      } else if (data.value == 'Unsafe Condition') {
                        observationController.clickType.value = 3;
                      }
                      dropDownMap[code] == val;
                      var radiolist1 = subCommon
                          .where((element) => element.id == val)
                          .toList();
                      var controlIds = radiolist1[0].controlIds;
                      if (controlIds != " ") {
                        observationDetails = true;
                        observationSubDetails = false;
                        _WidgetObservationDetails.clear();
                        _WidgetObservationDetails.length = 0;
                        _WidgetObservationSubDetails.clear();
                        _WidgetObservationSubDetails.length = 0;
                        _unSafeActSelected.clear();
                        _unSafeActSubSelected.clear();
                        print("not empty");
                        number = 2;
                        getPropertyHidder(controlIds);
                      } else {
                        observationDetails = false;
                        observationSubDetails = false;
                        print("empty");
                        number = 1;
                        _WidgetObservationDetails.clear();
                        _WidgetObservationDetails.length = 0;
                        _WidgetObservationSubDetails.clear();
                        _WidgetObservationSubDetails.length = 0;
                        _unSafeActSelected.clear();
                        _unSafeActSubSelected.clear();
                      }
                      radioSelected = val;
                      Logger logger = Logger();
                      logger.d(radioSelected);
                    });
                  },
                ))
            .toList(),
      );
    });
  }

  List<Map<String, dynamic>> buildNestedDropdown(List<dynamic> jsonData,
      {String? parentID}) {
    final List<Map<String, dynamic>> result = [];

    for (final item in jsonData) {
      final Map<String, dynamic> itemMap = item;

      if (itemMap['parentId'] == parentID) {
        final List<Map<String, dynamic>> children =
            buildNestedDropdown(jsonData, parentID: itemMap['id']);
        if (children.isNotEmpty) {
          itemMap['children'] = children;
        }
        result.add(itemMap);
      }
    }

    return result;
  }

  void _onDropdownChanged(dynamic selectedValue, String code) {
    if (selectedValue is Map<String, dynamic>) {
      Map<String, dynamic> selectedItem = selectedValue;
      print('Selected Item: ${selectedItem['id']}');
      String result = "${code[0].toLowerCase()}${code.substring(1)}";
      dropDownMap[result] = selectedItem['id'];
      organizationSelection = selectedItem['id'];
      print(dropDownMap[result]);
    }
  }

  List<DropdownMenuItem<Map<String, dynamic>>> buildDropdownMenuItems(
      List<Map<String, dynamic>> items,
      {int level = 0}) {
    final List<DropdownMenuItem<Map<String, dynamic>>> menuItems = [];

    for (final item in items) {
      final String displayName = item['displayName'];
      allCountryNames.add(displayName);
      final String displayText =
          level == 0 ? displayName : (' ' * (level * 4)) + displayName;
      menuItems.add(
        DropdownMenuItem<Map<String, dynamic>>(
          value: item,
          child: Text(displayText),
        ),
      );

      if (item.containsKey('children')) {
        menuItems
            .addAll(buildDropdownMenuItems(item['children'], level: level + 1));
      }
    }

    return menuItems;
  }

  Widget organizationBox(var code) {
    _Widget.add(dynamicText(code, textColor: textColor));
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return Container(
            margin:
                const EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 15),
            padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                border: Border.all(color: dynamicTextBorderColor, width: 1),
                color: Colors.white),
            child: Column(
              children: <Widget>[
                DropdownButtonFormField(
                  isExpanded: true,
                  hint: Text('Select an item'),
                  items: buildDropdownMenuItems(dropdownItems),
                  //suraj observation list
                  onChanged: (value) {
                    setState(() {
                      _onDropdownChanged(value, code);
                    });
                  },
                ),
              ],
            ));
      },
    );
  }

  Widget masterDropDownBox(var code) {
    var radiolist = subCommon
        .where((element) => element.masterDataObjectId == code)
        .toList();
    _Widget.add(
        dynamicText(radiolist[0].masterDataObjectValue, textColor: textColor));
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Container(
          margin: const EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 10),
          padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(color: dynamicTextBorderColor, width: 1),
              color: Colors.white),
          child: Column(
            children: <Widget>[
              new DropdownButton(
                isExpanded: true,
                iconEnabledColor: headerColor,
                iconDisabledColor: headerColor,
                iconSize: 40,
                dropdownColor: Colors.white,
                items: radiolist.map((e) {
                  return new DropdownMenuItem(
                    child: new Text(
                      e.value.toUpperCase(),
                      style: TextStyle(color: headerColor, fontFamily: 'Inter'),
                    ),
                    value: e.id.toString(),
                  );
                }).toList(),
                onChanged: (newvalue) {
                  box.put('riskList', radiolist.map((e) => e.value).toList());
                  logger.i(box.get('riskList'));

                  var radiolist1 = subCommon
                      .where((element) => element.id == newvalue)
                      .toList();
                  print(radiolist1[0].controlIds);
                  var add = 0;
                  if (radiolist1[0].controlIds.isNotEmpty) {
                    add = 1;
                    getPropertyHidder(radiolist1[0].controlIds);
                  } else {
                    if (add == 1) {
                      setState(() {
                        var count = _Widget.length;
                        _Widget.removeAt(count - 1);
                        add == 0;
                      });
                    }
                  }
                  String result =
                      "${code[0].toLowerCase()}${code.substring(1)}";
                  dropDownMap[result] = newvalue;
                  setState(() {
                    positionSelection = newvalue;
                  });
                },
                value: positionSelection,
              )
            ],
          ));
    });
  }

  Widget datePicker(TextEditingController controller, var code) {
    controller.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Container(
          height: 50,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: boxDecoration(
              showShadow: false,
              bgColor: ehs_white,
              radius: 4,
              color: dynamicTextBorderColor),
          padding: EdgeInsets.all(0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  hintStyle:
                      TextStyle(color: hintColor, fontSize: textSizeMedium),
                  border: InputBorder.none,
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    print(pickedDate);
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    print(formattedDate);
                    setState(() {
                      controller.text = formattedDate;
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                onChanged: (text) {
                  setState(() {
                    dateOfAudits = text;
                  });
                },
              ))
            ],
          ));
    });
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset offset = Offset(0.0, overlay.size.height);

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
          offset & Size(40, 40), Offset.zero & overlay.size),
      items: (observationController.clickType.value == 2)
          ? observationController.unsafeActList.map((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()
          : observationController.unsafeConditionsList.map((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          widget._selectedValue = value;
          observationController.textToShort.value = value;
        });
      }
    });
  }

  String getCurrentTimeFormatted() {
    final now = DateTime.now();
    return DateFormat('HH:mm:ss').format(now);
  }

  Widget timePicker(TextEditingController controller, var code) {
    final controller = TextEditingController(text: getCurrentTimeFormatted());
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: boxDecoration(
              showShadow: false,
              bgColor: ehs_white,
              radius: 4,
              color: dynamicTextBorderColor),
          padding: EdgeInsets.all(0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  hintStyle:
                      TextStyle(color: hintColor, fontSize: textSizeMedium),
                  border: InputBorder.none,
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  if (pickedTime != null) {
                    setState(() {
                      controller.text = pickedTime.format(context);
                    });
                  } else {
                    print("Time is not selected");
                  }
                },
                onChanged: (text) {
                  setState(() {
                    timeOfAudits = text;
                  });
                },
              ))
            ],
          ));
    });
  }
}
