import 'dart:math';
import 'package:ehs_new/Screens/Observation/OfflineEdit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'offlineObservationview.dart';

class OffileObsPage extends StatefulWidget {
  const OffileObsPage({super.key});

  @override
  State<OffileObsPage> createState() => _OffileObsPageState();
}

class _OffileObsPageState extends State<OffileObsPage> {
  @override
  Widget build(BuildContext context) {
    int randomInt = Random().nextInt(9);
    var box = Hive.box('myBox');
    int length = box.containsKey("length") ? box.get("length") : 0;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Observation List',
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
      body: ListView.builder(
          itemCount: length,
          itemBuilder: (context, index) {
            var map = box.get('$index');
            if (map != {}) {
              return InkWell(
                onTap: () {
                  Get.to(() => OfflineObservationView(
                        map: map,
                      ));
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
                            "OBS No: OBSV_03-2024-9$index",
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
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Stage: Closed",
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
                        "Observation Date: ${map['ObservationDate']}",
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
                            Get.to(() => OfflineEdit(
                                  index: index,
                                ));
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
                            box.delete("$index");
                            box.put("length", --length);
                            setState(() {});
                            // setState(() {
                            //   showAlert(
                            //     context,
                            //     index,
                            //     observation[index].recordNo,
                            //     observation[index].id,
                            //   );
                            // });
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
              );
            } else {
              return Center(
                child: Text("Sorry no data is available in offile mode"),
              );
            }
          }),
    );
  }
}
