import 'package:ehs_new/utils/AppConstant.dart';

final Uri getToken = Uri.parse(baseUrl + 'connect/token?__tenant=');
final Uri getUsers = Uri.parse(baseUrl + 'api/identity/users');
final Uri getObservation = Uri.parse(baseUrlTenants +
    'observations-service/observations/observation_list?ReturnAllProperties=true');
final Uri getIncident = Uri.parse(baseUrlTenants +
    'incident-service/incident-managements/incident-management_list?ReturnAllProperties=true&maxResultCount=1000');
final Uri getAudits = Uri.parse(baseUrlTenants +
    'inspection-service/audits-managements/audit_service_list?ReturnAllProperties=true');
final Uri getInspections = Uri.parse(baseUrlTenants +
    'inspection-service/inspection-managements/InspectionManagement_list?ReturnAllProperties=true');
final Uri getTanent =
    Uri.parse(baseUrlTenants + 'saas/tenants?maxResultCount=1000');
final Uri getMember = Uri.parse(baseUrlTenants +
    'employee-service/employees/list_employee?MaxResultCount=1000');
final Uri getMasterData = Uri.parse(
    baseUrlTenants + 'observations-service/master-datas?MaxResultCount=1000');
final Uri getFeature =
    Uri.parse(baseUrlTenants + 'feature-management/features?ProviderName=T');
final Uri getOrganization =
    Uri.parse(baseUrlTenants + '/identity/organization-units/all');
final Uri getAuditMasterData = Uri.parse(
    baseUrlTenants + '/inspection-service/master-datas?MaxResultCount=1000');
final Uri getInspectionMasterData = Uri.parse(
    baseUrlTenants + '/inspection-service/master-datas?MaxResultCount=1000');
final Uri getIncidentMasterData = Uri.parse(
    baseUrlTenants + 'incident-service/master-datas?MaxResultCount=1000');
final Uri getObservationMasterData = Uri.parse(
    baseUrlTenants + 'observations-service/master-datas?MaxResultCount=1000');
final String getObsvComments =
    baseUrlTenants + 'userTask-service/task-comments/task-comment-list';
final Uri createAuditComments =
    Uri.parse(baseUrlTenants + 'userTask-service/task-comments');
final Uri createAttachments =
    Uri.parse(baseUrlTenants + 'attachment-service/attachments');
final Uri saveAttachments =
    Uri.parse(baseUrlTenants + 'attachment-service/attachments/save-blob');
final Uri getAttachments = Uri.parse(baseUrlTenants +
    'attachment-service/attachments?ReturnAllProperties=true&MaxResultCount=1000');
final String getAtt = baseUrlTenants +
    'attachment-service/attachments?ReturnAllProperties=true&MaxResultCount=1000&';

final Uri createAudits =
    Uri.parse(baseUrlTenants + 'inspection-service/audits-managements');
final Uri createInspections =
    Uri.parse(baseUrlTenants + 'inspection-service/inspection-managements');
final Uri createObservations =
    Uri.parse(baseUrlTenants + 'observations-service/observations');
final Uri createIncidents =
    Uri.parse(baseUrlTenants + 'incident-service/incident-managements');
final String updateAuditDetails =
    baseUrlTenants + 'inspection-service/audits-managements';
final String updateIncidentDetails =
    baseUrlTenants + 'inspection-service/incident-managements';
final String updateInspectionDetails =
    baseUrlTenants + 'inspection-service/inspection-managements';
final String updateObservationDetails =
    baseUrlTenants + 'observations-service/observations';

const String GRANT_TYPE = "grant_type";
const String SCOPE = "scope";
const String USERNAME = "username";
const String PASSWORD = "password";
const String CLIENT_ID = "client_id";
const String CLIENT_SECRET = "client_secret";
const String REDIRECT_URI = "redirect_uri";
const String TENANT_ID = "tenantId";

const String Error = "invalid_grant";
const String TOKEN = "token";
const String COMPANY = "company";
var AuditData = "auditData";
var ObservationData = "observationData";

const String PWD_REQUIRED = "Password is Required";
const String PWD_LENGTH = "password should be more then 6 char long";
const String USER_REQUIRED = "Username is Required";
const String uploadFile = "Browse and choose the file to upload";

double deviceWidth = 0.0;
double deviceHeight = 0.0;

const String IDENTITY = "Identity";
const String OBSERVATION = "ObservationsService";
const String INCIDENTS = "IncidentService";
const String ACTION = "ActionService";
const String AUDIT = "AuditLogging";
const String ADMINISTRATION = "AdministrationService";
const String ATTACHMENT = "AttachmentService";
const String ADDRESS = "address";
const String AUTHSERVER = "AuthServer";
const String BBS = "BbsService";
const String CUSTOMER = "CustomerService";
const String EMAIL = "email";
const String EMPLOYEE = "EmployeeService";
const String FILEMANAGEMENT = "FileManagement";
const String FORMS = "Forms";
const String HSEPLAN = "HSEPlansService";
const String INSPECTION = "InspectionService";
const String NCR = "NCRService";
const String OPENID = "openid";
const String PHONE = "phone";
const String PRODUCT = "ProductService";
const String PROFILE = "profile";
const String RM = "RMService";
const String ROLE = "role";
const String SAAS = "SaasService";
const String TM = "TMService";
const String USERTASK = "UserTaskService";
