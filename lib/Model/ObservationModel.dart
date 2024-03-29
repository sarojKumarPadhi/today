class ObservationModel {
  late String recordNo;
  late String organizationUnitId;
  late String exactLocation;
  late String observationDate;
  late String time;
  late String observationStatus;
  late String observationStage;
  late String notification;
  late String observationType;
  late String description;
  late String perceivedRiskOrOpportunity;
  late String geoLocation;
  late String wereImmediateActionsTakenToReduceTheRisk;
  late String taskScheduleId;
  late String immediateActionsTaken;
  late String comments;
  late String reportingBy;
  late String reportedDateAndTime;
  late String typeOfUnsafeCondition;
  late String unsafeConditions;
  late String unsafeConditions_OthersComments;
  late String unsafeActType;
  late String unsafeActType_OthersComments;
  late String reactionOfPeople;
  late String personalProtectiveEquipment;
  late String positionOfPeople;
  late String toolsAndEquipment;
  late String proceduresAndOrderlinessAndHouseKeeping;
  late String roadSafety;
  late String vehicleRelatedUnsafeCondition;
  late String hseReviewerComment;
  late String dateReviewed;
  late String reviewedBy;
  late String recordType;
  late String customField1;
  late String customField2;
  late String customField3;
  late String customField4;
  late String customField5;
  late String customField6;
  late String customField7;
  late String customField8;
  late String customField9;
  late String customField10;
  late String observationDataValidateStage;
  late String observationDataValidatedStages;
  late String id;
  late String observationOrganizationDisplayName;
  late String observationReportingByDisplayName;
  late String observationReviewedByDisplayName;
  late String observationObservationTypeDisplayName;

  ObservationModel(
      this.recordNo,
      this.observationDate,
      this.observationStage,
      this.reportedDateAndTime,
      this.id,
      this.observationOrganizationDisplayName,
      this.observationReportingByDisplayName,
      this.observationReviewedByDisplayName,
      this.observationObservationTypeDisplayName,
      this.exactLocation,
      this.time,
      this.description,
      this.personalProtectiveEquipment,
      this.reactionOfPeople,
      this.perceivedRiskOrOpportunity,
      this.unsafeActType,
      this.comments,
      this.dateReviewed,
      this.hseReviewerComment);

  Map<String, dynamic> toMap() {
    return {
      'recordNo': recordNo,
      'organizationUnitId': organizationUnitId,
      'exactLocation': exactLocation,
      'observationDate': observationDate,
      'time': time,
      'observationStatus': observationStatus,
      'observationStage': observationStage,
      'notification': notification,
      'observationType': observationType,
      'description': description,
      'perceivedRiskOrOpportunity': perceivedRiskOrOpportunity,
      'geoLocation': geoLocation,
      'wereImmediateActionsTakenToReduceTheRisk':
          wereImmediateActionsTakenToReduceTheRisk,
      'taskScheduleId': taskScheduleId,
      'immediateActionsTaken': immediateActionsTaken,
      'comments': comments,
      'reportingBy': reportingBy,
      'reportedDateAndTime': reportedDateAndTime,
      'typeOfUnsafeCondition': typeOfUnsafeCondition,
      'unsafeConditions': unsafeConditions,
      'unsafeConditions_OthersComments': unsafeConditions_OthersComments,
      'unsafeActType': unsafeActType,
      'unsafeActType_OthersComments': unsafeActType_OthersComments,
      'reactionOfPeople': reactionOfPeople,
      'personalProtectiveEquipment': personalProtectiveEquipment,
      'positionOfPeople': positionOfPeople,
      'toolsAndEquipment': toolsAndEquipment,
      'proceduresAndOrderlinessAndHouseKeeping':
          proceduresAndOrderlinessAndHouseKeeping,
      'roadSafety': roadSafety,
      'vehicleRelatedUnsafeCondition': vehicleRelatedUnsafeCondition,
      'hseReviewerComment': hseReviewerComment,
      'dateReviewed': dateReviewed,
      'reviewedBy': reviewedBy,
      'recordType': recordType,
      'customField1': customField1,
      'customField2': customField2,
      'customField3': customField3,
      'customField4': customField4,
      'customField5': customField5,
      'customField6': customField6,
      'customField7': customField7,
      'customField8': customField8,
      'customField9': customField9,
      'customField10': customField10,
      'observationDataValidateStage': observationDataValidateStage,
      'observationDataValidatedStages': observationDataValidatedStages,
      'id': id,
      'observationOrganizationDisplayName': observationOrganizationDisplayName,
      'observationReportingByDisplayName': observationReportingByDisplayName,
      'observationReviewedByDisplayName': observationReviewedByDisplayName,
      'observationObservationTypeDisplayName':
          observationObservationTypeDisplayName,
    };
  }
}
