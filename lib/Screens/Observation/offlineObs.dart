import 'package:ehs_new/Utils/color.dart';
import 'package:ehs_new/controller/observationController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';

class OffineObs extends StatefulWidget {
  const OffineObs({Key? key}) : super(key: key);

  @override
  _OffineObsState createState() => _OffineObsState();
}

class _OffineObsState extends State<OffineObs> {
  var box = Hive.box('myBox');
  String? _selectedCountry;
  String? _seletedRisk;
  String? _selectedEmployee;
  String? _selectedOption;
  String? _selectedValue;
  ObservationController observationController =
      Get.put(ObservationController());
  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F6),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Observation',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color(0xFFF5F5F6),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: dynamicText("OrganizationUnitId",
                    textColor: const Color(0xFF145d87)),
              ),
            ),
            GestureDetector(
              onTap: () {
                _showDropdown(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCountry ?? 'Select an item',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: dynamicText("ExactLocation",
                      textColor: const Color(0xFF145d87))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextBox(
                textEditingController:
                    observationController.exactLocationController,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: dynamicText("ObservationDate",
                    textColor: const Color(0xFF145d87)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextBox(
                textEditingController: observationController.obsDateController,
              ),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: Text('Safe Act & Safe Condition'),
                  value: 'Safe Act & Safe Condition',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                      observationController.clickType.value = 1;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Unsafe Act'),
                  value: 'Unsafe Act',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                      observationController.clickType.value = 2;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Unsafe Condition'),
                  value: 'Unsafe Condition',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                      observationController.clickType.value = 3;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: dynamicText("Descriptions",
                      textColor: const Color(0xFF145d87))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextBox(
                textEditingController:
                    observationController.descriptionController,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: dynamicText("Perceived Risk Or Opportunity",
                      textColor: const Color(0xFF145d87))),
            ),
            GestureDetector(
              onTap: () {
                _preDialog(context);
                // suraj
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _seletedRisk ?? 'Select an item',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: dynamicText("Comments",
                      textColor: const Color(0xFF145d87))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextBox(
                textEditingController: observationController.commentsController,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: dynamicText("ReportedDate And Time",
                      textColor: const Color(0xFF145d87))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextBox(
                textEditingController:
                    observationController.reportedDateController,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: dynamicText("Reported By",
                      textColor: const Color(0xFF145d87))),
            ),
            // reportedBy(context),
            GestureDetector(
              onTap: () {
                reportedByDialog(context); // suraj
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _seletedRisk ?? 'Select an item',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),
            Obx(() {
              return observationController.clickType.value == 2 ||
                      observationController.clickType.value == 3
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 130, 0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                            child: dynamicText("WereImmediateActions...",
                                textColor: textColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: headerColor, // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            child: TextField(
                              controller: observationController
                                  .immidiateActionController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 12),
                                hintText:
                                    'WereImmediateActions...', // Placeholder text
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical:
                                        12.0), // Padding for the text input
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color:
                                        headerColor, // Border color when focused
                                    width: 1.0, // Border width when focused
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color:
                                        headerColor, // Border color when enabled
                                    width: 0.0, // Border width when enabled
                                  ),
                                ),
                                suffixIcon: DropdownButton<String>(
                                  onChanged: (String? value) {
                                    observationController
                                        .immidiateActionController
                                        .text = value ?? '';
                                    // Handle dropdown value changes here
                                  },
                                  items:
                                      <String>['Yes', 'No'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  icon: Icon(
                                      Icons.arrow_drop_down), // Dropdown icon
                                  iconSize: 30, // Icon size
                                  elevation:
                                      16, // Elevation for the dropdown menu
                                  underline: Container(), // Remove underline
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox();
            }),
            Obx(() {
              return (observationController.clickType.value == 2 ||
                      observationController.clickType.value == 3)
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                              child: dynamicText(
                                observationController.clickType.value == 2
                                    ? "Unsafe Act Type             "
                                    : "Types of Unsafe Condition",
                                textColor: textColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // Align widgets to the start of the row
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _showPopupMenu(
                                          context); // Function to show the popup menu
                                    },
                                    child: Container(
                                      width: 320,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: headerColor, // Border color
                                          width: 1.0, // Border width
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 12.0),
                                      child: Text(
                                        _selectedValue ??
                                            'Select an option', // Text to display
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black, // Text color
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox();
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonTheme(
                minWidth: double.infinity,
                child: MaterialButton(
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  onPressed: () {
                    int length =
                        box.containsKey("length") ? box.get("length") : -1;

                    Map<String, dynamic> offileMap = {
                      "OrganizationUnitId": _selectedCountry ?? "",
                      "ExactLocation":
                          observationController.exactLocationController.text,
                      "ObservationDate":
                          observationController.obsDateController.text,
                      "checkOption": observationController.clickType.value,
                      "Description":
                          observationController.descriptionController.text,
                      "perceivedRisk": _seletedRisk,
                      "comments": observationController.commentsController.text,
                      "ReportedDate":
                          observationController.reportedDateController.text,
                      "ReportedBy": _selectedEmployee,
                    };
                    box.put("$length", offileMap);
                    logger.d(box.get("$length"));
                    box.put("length", ++length);
                    Get.back();
                  },
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void reportedByDialog(BuildContext context) {
    if (box.get('employeeList') != null) {
      List<String> employeeList = box.get('employeeList');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select an employee'),
            content: DropdownButton<String>(
              value: _selectedEmployee,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEmployee = newValue;
                });
                Navigator.pop(context);
              },
              items: employeeList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          );
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Plz make a observation record in online mode once in lifetime");
    }
  }

  void _preDialog(BuildContext context) {
    if (box.get('riskList') != null) {
      List<String> OrdUnitList = box.get('riskList');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select an item'),
            content: DropdownButton<String>(
              value: _seletedRisk,
              onChanged: (String? newValue) {
                setState(() {
                  _seletedRisk = newValue;
                });
                Navigator.pop(context);
              },
              items: OrdUnitList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          );
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Plz make a observation record in online mode once in lifetime");
    }
  }

  void _showDropdown(BuildContext context) {
    if (box.get('OrgUnitId') != null) {
      List<String> OrdUnitList = box.get('OrgUnitId');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select an item'),
            content: DropdownButton<String>(
              value: _selectedCountry,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCountry = newValue;
                });
                Navigator.pop(context);
              },
              items: OrdUnitList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          );
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Plz make a observation record in online mode once in lifetime");
    }
  }

  Widget dynamicText(
    String text, {
    Color? textColor,
    String? fontFamily,
    bool isCentered = false,
    int maxLine = 2,
    double latterSpacing = 0.5,
    bool textAllCaps = false,
    bool isLongText = false,
    bool lineThrough = false,
  }) {
    return Text(
      textAllCaps ? text.toUpperCase() : text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: isLongText ? null : maxLine,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: fontFamily ?? 'Inter',
        fontSize: 16,
        color: textColor,
        height: 1.5,
        letterSpacing: latterSpacing,
        decoration:
            lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
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
        // Update the selected value
        setState(() {
          _selectedValue = value;
          observationController.textToShort.value = value;
        });
      }
    });
  }
}

class TextBox extends StatelessWidget {
  final TextEditingController textEditingController;

  const TextBox({super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter text...',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
