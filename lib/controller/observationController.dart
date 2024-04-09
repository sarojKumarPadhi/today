import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ObservationController extends GetxController {
  TextEditingController immidiateActionController = TextEditingController();
  TextEditingController exactLocationController = TextEditingController();
  TextEditingController obsDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController perceivedController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  TextEditingController reportedDateController = TextEditingController();
  TextEditingController reportedByController = TextEditingController();
  RxString textToShort = ''.obs;
  RxInt clickType = 0.obs;

  final List<String> unsafeActList = [
    'Tools and Equipment',
    'Reaction of People',
    'Procedures Orderliness/HouseKeeping',
    'PPE',
    'Vehicle/Traffic Related',
    'Position of People',
    'Others',
  ];
  final List<String> unsafeConditionsList = [
    'Vehicle Related Unsafe Condition',
    'Unsafe Conditions'
  ];
  final List<String> unsafeConditionOptionsList = [
    'Access & Egress',
    'Poor Communication',
    'Sharp Edge',
    'Un Isolated Electrical/Mechanical Devices',
    'Leaking Hazardous Chemical Area Pinch Point',
    'Defective Tools or Equipment',
    'Inadequate Guarding',
    'Tripping',
    'Poor Condition of Safety Device',
    'Temperature/Heat Exposure',
    'Inadequate Engineering Design',
    'High Pressure',
    'Inadequate Procedure/Standards',
    'Falling',
    'Inadequate PPE',
    'Poor House Keeping',
    'Poor Visibility Spart',
    'Congested/Restricted Area',
    'Noise Exposure',
    'Dust Hazard',
    'Slipping Hazard',
    'Others',
    'Testing',
  ];

  final List<String> ToolsandEquipment = [
    'Used Incorrectly',
    'wrong For The Job',
    'In Unsafe Condition',
  ];
  final List<String> ReactionofPeople = [
    'Stopping Job',
    'Adjusting Personal Protective Equipment'
        'Changing Position'
        'Rearranging Job'
        'Performing Lockouts'
        'Attaching Ground'
  ];

  final List<String> ProceduresOrderlinessHouseKeeping = [
    'Procedures Inadequate'
        'Procedures Not Known/Understood'
        'Procedures Not Followed Orderliness Standard Inadequate'
        'Orderliness Standard Not Followed'
        'Orderliness Standard Not Known/Understood'
  ];

  final List<String> PPE = [
    'Trunk',
    'Ears',
    'Eyes and Face',
    'Arms and Hands',
    'Respiratory System',
    'Head',
    'Legs and Feet'
  ];

  final List<String> VehicleTrafficRelated = [
    'Driving Without Seatbelt',
    'Other Traffic Violation',
    'Using GSM while Driving',
    'Over Speeding',
  ];

  final List<String> PositionofPeople = [
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
  ];
  final List<String> vehicleRelatedUnsafeConditionOptionsList = [
    'Poor Condition Tyres',
    'First Aid Box Missing',
    'Defective Seat Belt',
    'Jack & Tools not Available',
    'Breaks not Working',
    'Fire Extinguisher Missing',
  ];
}
