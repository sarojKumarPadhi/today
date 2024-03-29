class IncidentModel{
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
  var id;
  var recordNo;
  var organizationUnitId;
  var incidentTitle;
  var dateOfIncident;
  var status;
  var stage;
  var incidentManagementOrganizationDisplayName;
  var incidentManagementStatusDisplayName;
  var incidentManagementEventTypeDisplayName;
  var incidentManagementWorkRelatedDisplayName;
  var incidentManagementIncidentTypeDisplayName;
  var incidentManagementSupervisorOnDutyDisplayName;
  var incidentManagementReportedByDisplayName;
  var supervisorOnDuty;
  var timeOfIncident;
  var incidentDescription;
  var immediateCorrectiveActionTaken;
  var reportedBy;
  var dateReported;
  var eventType;
  var workRelated;
  var otherReportedBy;

  IncidentModel(this.id, this.stage, this.status, this.recordNo, this.organizationUnitId, this.incidentManagementOrganizationDisplayName, this.incidentTitle, this.dateOfIncident,
      this.timeOfIncident, this.eventType, this.incidentManagementEventTypeDisplayName, this.workRelated, this.incidentManagementWorkRelatedDisplayName,
      this.supervisorOnDuty, this.incidentManagementSupervisorOnDutyDisplayName, this.incidentDescription, this.immediateCorrectiveActionTaken,
      this.reportedBy, this.incidentManagementReportedByDisplayName,
      this.otherReportedBy, this.dateReported);

}