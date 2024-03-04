import 'app_enviroment.dart';

String DevlopmentUrl = "https://apivcarestage.vcareprojectmanagement.com/api/v2/";
String ProductionUrl = "https://pgmp4uapiconnect.vcareprojectmanagement.com/api/v2/";

String _BASE_URL = AppEnvironment.environment == Environments.STAGING ? DevlopmentUrl : ProductionUrl;

String UPDATE_NOTIFICATION = _BASE_URL + "updateNotification";
String IN_APP_PURCHASE = _BASE_URL + "InAppPurchasePayment";
String GMAIL_REGISTER = _BASE_URL + "GmailRegister";
String GMAIL_LOGIN = _BASE_URL + "GmailLogin";
String TAKE_PAYMENT = _BASE_URL + "TakePayment";
String USER_DETAILS = _BASE_URL + "UserDetails";
String CHECK_USER_PAYMENT_STATUS = _BASE_URL + "CheckUserPaymentStatus";
String ALL_MOCK_TESTS = _BASE_URL + "AllMockTests";
String REVIEWS_MOCK_TEST = _BASE_URL + "ReviewsMockTest";
String MOCK_TEST_DETAILS = _BASE_URL + "MockTestDetails";
String PRACTICE_TEST_QUESTIONS = _BASE_URL + "PracticeTestQuestions";
String MOCK_TEST = _BASE_URL + "MockTest";
String SUBMIT_MOCK_TEST = _BASE_URL + "SubmitMockTest";
String MOCK_TEST_QUESTIONS = _BASE_URL + "MockTestQuestions";
String CHECK_COUPON = _BASE_URL + "CheckCoupon";
String GET_RAZOR_PAY_ORDER_ID = _BASE_URL + "GetRazorPayOrderid";
String getHideShowStatus = _BASE_URL + "getMasterList";

String checkStatusFlashAndVideo = _BASE_URL + "checkStatus"; //new
String GetCategoryListUrl = _BASE_URL + "getCategoryList";
String GetCardUrl = _BASE_URL + "getCardDetailByCatId";

// String CREATE_ORDER = _BASE_URL2 + "createOrder";   check
// String videoListByTypeUrl = _BASE_URL2 + "videoListByViType";
String CREATE_ORDER = _BASE_URL + "createOrder";
String videoListByTypeUrl = _BASE_URL + "videoListByViType";

String InAppPurchasePaymentNew = _BASE_URL + "InAppPurchasePaymentNew"; //new
String stripeFlashCard = _BASE_URL + "createOrderNew?planType=2&deviceType=A"; //new
String stripeVideoLib = _BASE_URL + "createOrderNew?planType=3&deviceType=A";

String getCourseCategory = _BASE_URL + "getCourseCategory";
String getCourseSubCategory = _BASE_URL + "getCourseSubCategory";
String getSubCategoryDetails = _BASE_URL + "getSubCategoryDetails";
String deviceToken = _BASE_URL + "updateDeviceToken";
String chatUserListApi = _BASE_URL + "getChatUsers";
String sendChatUserNotification = _BASE_URL + "sendChatUsersNotification";

String UPDATE_DEVICE_TOKEN = _BASE_URL + "updateDeviceToken";
String GET_SUBSCRIPTION_STATUS = _BASE_URL + "getsubscriptionStatus";

String REVIEW_MOCK_DOMAIN = _BASE_URL + "ReviewsMockTestDomain";

// couses
String GET_COURSES = _BASE_URL + "getCourse";

// master
String GET_MASTER_DATA = _BASE_URL + "getMasterData";

// VIDEOS
String GET_VIDEOS = _BASE_URL + "getVideos";
String VIDEO_LIST_BY_VI_TYPE = _BASE_URL + "videoListByViType";

// practice

// mock
String GET_TEST_DETAILS = _BASE_URL + "gettestDetails";
String GET_TEST = _BASE_URL + "gettest";

// quest of the day
String SUBMIT_QUESTION_OF_THE_DAY = _BASE_URL + "submitQuestionOfTheDay";

// notification
String NOTIFICATION_LIST = _BASE_URL + "notificationList";

// logut

// chatUser

// flash
String GET_FLASH_CATEGORIES = _BASE_URL + "getFlashCategories";
String GET_VIDEO_CATEGORIES = _BASE_URL + "getVideoCategories";
String GET_FLASH_CARDS = _BASE_URL + "getFlashCards";

//new

String GET_QUES_OF_DAY = _BASE_URL + "getQuestionOfTheDay";
String MOCK_TEST_QUES = _BASE_URL + "MockTestQuestions";
String REVIEW_MOCK_TEST = _BASE_URL + "ReviewsMockTest";

// pdf
String GET_PPTS = _BASE_URL + "getPPts";
String GET_PPTS_DETAILS = _BASE_URL + "getPPtsDetails";

String SET_REMINDER = _BASE_URL + "setReminders";
String GET_REMINDER = _BASE_URL + "getReminders";

String GET_PPT_CATEGORIES = _BASE_URL + "getPPTCategories";
String GET_PPT = _BASE_URL + "getPPT";
String DELETE_ACCOUNT = _BASE_URL + "deleteMyAccount";

String GET_DOMAIN_CATEGORIES = _BASE_URL + "getDomainCategories";

String GET_TASKS = _BASE_URL + "getTasks";
String GET_SUB_DOMAIN = _BASE_URL + "getSubDomain";
String GET_DOMAIN = _BASE_URL + "getDomain";
String GET_TASK_DETAIL = _BASE_URL + "getTaskDetails";

String GET_SUBSCRIPTION_PACK = _BASE_URL + "getsubscriptionPacks";
String CREATE_SUBSCRIPTION_ORDER = _BASE_URL + "createSubscriptionOrder";
String JOIN_NOTIFICATION = _BASE_URL + "joinNotification";
String CANCEL_SUBSCRIPTION = _BASE_URL + "cancelSubscriptionPack";

String FREE_SUBSCRIPTION = _BASE_URL + "createSubscriptionOrderFree";
String RESTORE_SUBSCRIPTION = _BASE_URL + "restoreSubscriptionPack";

/// process api

String GET_PROCESS = _BASE_URL + "getProcess";
String GET_SUB_PROCESS = _BASE_URL + "getSubProcess";
String GET_TASKS_PROCESS = _BASE_URL + "getTasksProcess";
String GET_TASKS_PROCESS_DETAIL = _BASE_URL + "getTasksProcessDetails";
String GET_FREE_TRIAL = _BASE_URL + "getFreeTrials";

// String GET_DOMAIN = _BASE_URL + "getDomain";
// String GET_TASK_DETAIL = _BASE_URL + "getTaskDetails";




//cancelSubscriptionPack

//getPPT

//getPPTCategories
