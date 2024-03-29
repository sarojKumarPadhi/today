import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ObservationController extends GetxController {
  TextEditingController immidiateActionController = TextEditingController();
  RxString textToShort = ''.obs;
  RxInt clickType = 0.obs;
  final List<String> unsafeActList = [
    'Tools and Equipment',
    'Reaction of People',
    'Procedures Orderliness/HouseKeeping',
    'PPE',
    'Vehicle/Traffic Related',
    'Position of People',
    'others',
  ];
  final List<String> unsafeConditionsList = [
    'Vehicle Related Unsafe Condition',
    'Unsafe Condition'
  ];
}
