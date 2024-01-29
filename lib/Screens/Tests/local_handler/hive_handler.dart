import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pgmp4u/Models/restartModel.dart';

import '../../../Models/get_reminder_model.dart';
import '../../../Models/mockListmodel.dart';
import '../../../Models/mockquestionanswermodel.dart';
import '../../../Models/pptCateModel.dart';
import '../../../Models/pptDetailsModel.dart';
import '../../../Process/processTask_model.dart';
import '../../../Process/process_model.dart';
import '../../../Process/subprocess_model.dart';
import '../../Domain/screens/Models/domainModel.dart';
import '../../Domain/screens/Models/subDomainModel.dart';
import '../../Domain/screens/Models/taskModel.dart';
import '../../MockTest/model/courseModel.dart';
import '../../MockTest/model/flashCardModel.dart';
import '../../MockTest/model/flashCateModel.dart';
import '../../MockTest/model/masterdataModel.dart';
import '../../MockTest/model/pracTestModel.dart';
import '../../MockTest/model/quesOfDayModel.dart';
import '../../MockTest/model/taskQuesModel.dart';
import '../../MockTest/model/testDataModel.dart';
import '../../MockTest/model/testDetails.dart';
import '../model/categorymodel.dart';
import '../model/mock_test.dart';

class HiveHandler {

    static const String getReminderBox = "getReminderData";
  static const String getReminderBoxKey = "getReminderKey";

  static const String notSubmitBox = "notSubmitData";
  static const String notSubmitBoxKey = "notSubmitKey";

  static const String userDataBox = "categoryData";
  static const String userDataBoxKey = "categoryKey";

  static const String FlashCardBox = "flashData";
  static const String FlashDisplayBox = "flashDisplayBox";
  static const String FlashCardKey = "flashKey";

  static const String MockTestBox = "mockData";
  static const String MockTestKey = "mockKey";

  static const String PracticeTestBox = "practiceData";
  static const String PracticeTestKey = "practiceKey";

  static const String deviceTokenBox = "DeviceTokenBox";
  static const String deviceTokenKey = "deviceTokenKey";

  static const String MockQuesBox = "mockTestBox";
  static const String MockQuesKey = "mockTestKey";

  static const String MasterDataBox = "masterDataBox";
  static const String MasterDataKey = "masterDataKey";

  static const String MockRestartBoxKey = "mockRestartBox";
  static const String SubmitMockBoxKey = "mockSubmitBox";

  static const String CourseBox = "courseBox";
  static const String CourseKey = "courseKey";

  static const String pptCateBox = "pptCateBox";
  static const String pptCateKey = "pptCateKey";

  static const String taskQuesBox = "taskQuesBox";
  static const String taskQuesKey = "taskQuesKey";
  static const String processTaskQuesBox = "processTaskQuesBox";
  static const String processTaskQuesKey = "processTaskQuesKey";

  static const String quesOfDayBox = "quesOfDayBox";
  static const String quesOfDayKey = "quesOfDayKey";

  static const String pptDataBox = "pptDataBox";
  static const String pptDataKey = "pptDataKey";

  static const String DomainDetailBox = "domainBox";
  static const String DomainDetailKey = "domainKey";
  static const String SubDomainDetailBox = "subdomainBox";
  static const String SubDomainDetailKey = "subdomainKey";

  static const String FlashCateBox = "flashCateBox";

  static const String TestDataBox = "testListBox";
  static const String TestDataKey = "testListBox";

  static const String TestPercentBox = "testPercentBox";
  static const String TestPercentKey = "testPercentBox";

  static const String MockAttemptsBox = "moclAttemptBox";
  static const String MockQuestionBoxKey = "mockQuestionsBox";
  static const String TaskItemsBoxKey = "taskItemsBox";

  static const String ProcessDetailBox = "processBox";
  static const String ProcessDetailKey = "processKey";
  static const String SubProcessDetailBox = "subprocessBox";
  static const String SubProcessDetailKey = "subprocessKey";

  static const String ProcessTaskDetailBox = "processTaskBox";
  static const String ProcessTasDetailKey = "processTaskKey";



  static Box<String> processDetailListBox;
  static Box<String> subProcessDetailListBox;
  static Box<String> processTaskListBox;

  static Box<String> mockNotSubmitBox;
  static Box<String> courseListBox;
  static Box<String> displayFlashBox;
  static Box<String> flashListCateBox;
  static Box<String> domainDetailListBox;
  static Box<String> subDomainDetailListBox;

  static Box<String> pptCateDetailBox;
  static Box<String> pptDataDetailBox;
  static Box<List<CategoryListModel>> categoryListBox;
  static Box<List<FlashCardDetails>> flashListBox;

  static Box<String> masterListBox;
  static Box<String> pptCateListBox;
  static Box<RestartModel> mockRestartBox;
  static Box<CurrentSubscription> getReminderMapBox;
  static Box<String> submitDataBox;
  static Box<String> taskPracTestBox;
  static Box<String> processQuesBox;
  static Box<String> PracTestBox;

  static Box<List<MockTestListApiModel>> MockListBox;
  static Box<List<QuestionAnswerModel>> MockTextBox;
  static Box<String> MockQuestionBox;
  static Box<String> TaskItemsBox;
  static Box<String> ProcessTaskItemsBox;
  static Box<String> QuesOfDDayBox;

  // static Box<List<PracListModel>> PracTestBox;

  static Box<String> TestPMListBox;
  static Box<List<MockPercentModel>> TestPercentListBox;

  static Box<String> mockAttempList;

//MockPercentModel
  static Future hiveRegisterAdapter() async {
    await Hive.initFlutter();
   
    Hive.registerAdapter(CategoryListModelAdapter());
    Hive.registerAdapter(FlashCardDetailsAdapter());
    Hive.registerAdapter(DomainDetailsAdapter());
    Hive.registerAdapter(ProcessDetailsAdapter());
    Hive.registerAdapter(SubProcessDetailsAdapter());
    // Hive.registerAdapter(ProcessTaskDetailsAdapter());
    Hive.registerAdapter(SubDomainDetailsAdapter());
    Hive.registerAdapter(PPTCateDetailsAdapter());
    Hive.registerAdapter(PPTDataDetailsAdapter());
    Hive.registerAdapter(MasterDetailsAdapter());
    Hive.registerAdapter(MockTestListApiModelAdapter());
    Hive.registerAdapter(QuestionAnswerModelAdapter());
    Hive.registerAdapter(PracListModelAdapter());
    Hive.registerAdapter(CourseDetailsAdapter());
    Hive.registerAdapter(FlashCateDetailsAdapter());
    Hive.registerAdapter(AllDayQuestionModelAdapter());
    Hive.registerAdapter(TestDataDetailsAdapter());
    Hive.registerAdapter(MockDataDetailsAdapter());
    Hive.registerAdapter(RestartModelAdapter());
         Hive.registerAdapter(CurrentSubscriptionAdapter());
    Hive.registerAdapter(TaskQuesAdapter());


    mockNotSubmitBox = await Hive.openBox<String>(notSubmitBox);
    domainDetailListBox = await Hive.openBox<String>(DomainDetailBox);
    processDetailListBox = await Hive.openBox<String>(ProcessDetailBox);
    subProcessDetailListBox = await Hive.openBox<String>(SubProcessDetailBox);
    pptCateDetailBox = await Hive.openBox<String>(pptCateBox);
    pptDataDetailBox = await Hive.openBox<String>(pptDataBox);
    subDomainDetailListBox = await Hive.openBox<String>(SubDomainDetailBox);
    courseListBox = await Hive.openBox<String>(CourseBox);
    displayFlashBox = await Hive.openBox<String>(FlashCardBox);
    flashListCateBox = await Hive.openBox<String>(FlashCateBox);
    categoryListBox = await Hive.openBox<List<CategoryListModel>>(userDataBox);
    QuesOfDDayBox = await Hive.openBox<String>(quesOfDayBox);
    taskPracTestBox = await Hive.openBox<String>(taskQuesBox);
    processQuesBox = await Hive.openBox<String>(processTaskQuesBox);
    masterListBox = await Hive.openBox<String>(MasterDataBox);
    submitDataBox = await Hive.openBox<String>(SubmitMockBoxKey);

    // MockListBox = await Hive.openBox<List<MockTestListApiModel>>(MockTestBox);

    TaskItemsBox = await Hive.openBox<String>(TaskItemsBoxKey);
    ProcessTaskItemsBox = await Hive.openBox<String>(ProcessTasDetailKey);

    MockQuestionBox = await Hive.openBox<String>(MockQuestionBoxKey);

    TestPMListBox = await Hive.openBox<String>(TestDataBox);

    mockAttempList = await Hive.openBox<String>(MockAttemptsBox);

    mockRestartBox = await Hive.openBox<RestartModel>(MockRestartBoxKey);
    getReminderMapBox=await Hive.openBox<CurrentSubscription>(getReminderBox);
    await Hive.openBox("deviceTokenBox");

    await Hive.openBox("testPercentBox");
    await Hive.openBox("userDataBox");

    MockTextBox = await Hive.openBox<List<QuestionAnswerModel>>(MockQuesBox);
  }

  // TestPercentListBox start

  static setMockPercentdata({dynamic value, String key}) async {
    final box = Hive.box("testPercentBox");
    print("*********************************");
    print("incomimg valueeeeee=====>>>>$value");

    await box.put(key, jsonEncode(value));
  }

  static ValueListenable getMockPercentListener() {
    return Hive.box("testPercentBox").listenable();
  }

  static Future<dynamic> getMockTestPercent({String key}) async {
    final box = Hive.box("testPercentBox");
    return await box.get(key, defaultValue: "");
  }

  /// TestPercentListBox end

  static setstringdata({dynamic value, String key}) async {
    final box = Hive.box("deviceTokenBox");
    print("*********************************");
    print("incomimg valueeeeee=====>>>>$value");
    await box.put(key, jsonEncode(value));
  }

  static Future<dynamic> getstringdata({String key}) async {
    final box = Hive.box("deviceTokenBox");
    return await box.get(key, defaultValue: "");
  }

  static ValueListenable getPracTestListener() {
    return Hive.box("deviceTokenBox").listenable();
  }

  //// mock attempt start

  static addMockAttempt(String mockAttempts, String key) async {
    print("incomimg valueeeeee=====>>>>$mockAttempts");

    mockAttempList.put(key, mockAttempts);
    if (mockAttempList.containsKey(key)) {
     
      print("mockAttempList.get  key: $key, Data: ${mockAttempList.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static Future<String> getMockAttemptData({String key}) async {
    return mockAttempList.get(key, defaultValue: "");
  }

  static ValueListenable<Box<String>> getMockTestAttemptListener() {
    return Hive.box<String>(MockAttemptsBox).listenable() ?? "";
  }

  //// mock attempt end

/////////////

  static setMockData({String value, String key}) async {
    MockQuestionBox.put(key, value);
    if (MockQuestionBox.containsKey(key)) {
      // print("===========added to box=========");
      print("MockQuestionBox.get  Key: $key, Data:${MockQuestionBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getMockTestListener() {
    return Hive.box<String>(MockQuestionBoxKey).listenable() ?? '';
  }

  static setTaskItemsData({String value, String key}) async {
    List<TaskDetails> storedTaskAllData = [];
    TaskItemsBox.put(key, value);

    if (TaskItemsBox.containsKey(key)) {
     
      print("TaskItemsBox.get  Key: $key, Data:${TaskItemsBox.get(key)}");

      String taskData = TaskItemsBox.get(key);
      print(" >> taskData :  $taskData");

      List Tasklist = jsonDecode(taskData);

      storedTaskAllData = Tasklist.map((e) => TaskDetails.fromjson(e)).toList();
      print(" >> storedTaskAllData taskData :  ${storedTaskAllData[0].PracList}");
      debugPrint(" >> storedTaskAllData : $storedTaskAllData");
    } else {
      print("===========box is empty=========");
    }
  }

  static setProcessTaskItemsData({String value, String key}) async {
    List<ProcessTskDetails> storedProcessTaskData = [];
    ProcessTaskItemsBox.put(key, value);

    if (ProcessTaskItemsBox.containsKey(key)) {
   
      print("ProcessTaskItemsBox.get  Key: $key, Data:${ProcessTaskItemsBox.get(key)}");
      String processTaskData = ProcessTaskItemsBox.get(key);
      print(" >> processTaskData :  $processTaskData");
      List processTaskList = jsonDecode(processTaskData);
      print("processTaskList:::::::$processTaskList");

      storedProcessTaskData = processTaskList.map((e) => ProcessTskDetails.fromjson(e)).toList();
      debugPrint(" >> storedProcessTaskData : $storedProcessTaskData");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getTaskItemsListener() {
    return Hive.box<String>(TaskItemsBoxKey).listenable() ?? '';
  }

  static ValueListenable<Box<String>> getProcessTaskItemsListener() {
    return Hive.box<String>(ProcessTasDetailKey).listenable() ?? '';
  }

  static setTaskQuesData({String value, String key}) async {
    List<TaskQues> storedTaskTestQuesData = [];
    print("valueee of vallll>>>>>$value");
    print("value of keyyyy>>>>$key");
    taskPracTestBox.put(key, value);

    if (taskPracTestBox.containsKey(key)) {

      print("taskPracTestBox.get  Key: $key, Data:${taskPracTestBox.get(key)}");
      String taskQuesData = taskPracTestBox.get(key);
      print(" >> taskData :  $taskQuesData");
      List TaskquestionsList = jsonDecode(taskQuesData);
      storedTaskTestQuesData = TaskquestionsList.map((e) => TaskQues.fromJson(e)).toList();
      debugPrint(" >> storedTaskTestQuesData : $storedTaskTestQuesData");
    } else {
      print("===========box is empty=========");
    }
  }

  static setProcessTaskQuesData({String value, String key}) async {
    List<TaskQues> storedProcessQuesData = [];
    print("valueee of vallll>>>>>$value");
    print("value of keyyyy>>>>$key");
    processQuesBox.put(key, value);

    if (processQuesBox.containsKey(key)) {

      print("processQuesBox.get  Key: $key, Data:${processQuesBox.get(key)}");
      String taskQuesData = processQuesBox.get(key);
      print(" >> taskData :  $taskQuesData");
      List TaskquestionsList = jsonDecode(taskQuesData);
      storedProcessQuesData = TaskquestionsList.map((e) => TaskQues.fromJson(e)).toList();
      debugPrint(" >> storedProcessQuesData : $storedProcessQuesData");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getTaskQuesListener() {
    return Hive.box<String>(taskQuesBox).listenable() ?? '';
  }

  static ValueListenable<Box<String>> getProcessTaskQuesListener() {
    return Hive.box<String>(processTaskQuesBox).listenable() ?? '';
  }

  static setQuesOfDayData({String value, String key}) async {
    QuesOfDDayBox.put(key, value);
    if (QuesOfDDayBox.containsKey(key)) {
    
      print("QuesOfDDayBox.get  Key: $key, Data:${QuesOfDDayBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getQuesOfDayListener() {
    return Hive.box<String>(quesOfDayBox).listenable() ?? '';
  }

  static addCategory(List<CategoryListModel> list) async {
    final Box<List<CategoryListModel>> categoryListBox = await Hive.openBox<List<CategoryListModel>>(userDataBox);
    categoryListBox.put(userDataBoxKey, list);
  }

  static ValueListenable<Box<List<CategoryListModel>>> getCategoryListener() {
    return Hive.box<List<CategoryListModel>>(userDataBox).listenable();
  }

  static List<CategoryListModel> getCategoryList() {
    try {
      final List<CategoryListModel> storedCategories = categoryListBox.get(userDataBoxKey);
      print("storedCategories list length ${storedCategories.length}");
      return storedCategories;
    } catch (e) {
      return [];
    }
  }

  static addPracTest(List<PracTestModel> list) async {
    final Box<List<PracTestModel>> pracListBox = await Hive.openBox<List<PracTestModel>>(PracticeTestBox);
    pracListBox.put(PracticeTestKey, list);
  }

  static ValueListenable<Box<List<PracTestModel>>> getPracListener() {
    return Hive.box<List<PracTestModel>>(PracticeTestBox).listenable();
  }

  static addFlashDisplayData(String flashListResponse, String key) async {
    displayFlashBox.put(key, flashListResponse);

    if (displayFlashBox.containsKey(key)) {
    
      print("displayFlashBox.get ${displayFlashBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getDisplayFlashListener() {
    return Hive.box<String>(FlashCardBox).listenable() ?? "";
  }

  static addDomainDetailData(String domainDetailResponse, String key) async {
    domainDetailListBox.put(key, domainDetailResponse);

    if (domainDetailListBox.containsKey(key)) {

      print("domainDetailListBox.get ${domainDetailListBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getDomainDetailListener() {
    return Hive.box<String>(DomainDetailBox).listenable() ?? "";
  }

  static ValueListenable<Box<String>> getProcessDetailListener() {
    return Hive.box<String>(ProcessDetailBox).listenable() ?? "";
  }

  static ValueListenable<Box<String>> getSubProcessDetailListener() {
    return Hive.box<String>(SubProcessDetailBox).listenable() ?? "";
  }

  static addpptCateData(String pptCateResponse, String key) async {
    pptCateDetailBox.put(key, pptCateResponse);
    print("value of keyyy>>>> $key");

    if (pptCateDetailBox.containsKey(key)) {

      print("pptCateDetailBox.get ${pptCateDetailBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getPptCateListener() {
    return Hive.box<String>(pptCateBox).listenable() ?? "";
  }

  static addpptDataBox(String pptDataResponse, String key) async {
    pptDataDetailBox.put(key, pptDataResponse);
    print("value of keyyy>>>> $key");

    if (pptDataDetailBox.containsKey(key)) {

      print("pptDataDetailBox.get ${pptDataDetailBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getPptDataListener() {
    return Hive.box<String>(pptDataBox).listenable() ?? "";
  }

  static addsubDomainDetailData(String subdomainDetailResponse, String key) async {
    subDomainDetailListBox.put(key, subdomainDetailResponse);

    if (subDomainDetailListBox.containsKey(key)) {
      print("subdomain box keyy>>>>>>>.$key");

      print("subDomainDetailListBox.get ${subDomainDetailListBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static addProcessDetailData(String processDetailResponse, String key) async {
    print("processDetailResponse>>>>$processDetailResponse");
    print("process detail key>>>.$key");
    processDetailListBox.put(key, processDetailResponse);

    if (processDetailListBox.containsKey(key)) {
      print("subdomain box keyy>>>>>>>.$key");
     
      print("processDetailListBox.get ${processDetailListBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static addsubProcessDetailData(String subProcessDetailResponse, String key) async {
    subProcessDetailListBox.put(key, subProcessDetailResponse);

    if (subProcessDetailListBox.containsKey(key)) {
      print("subdomain box keyy>>>>>>>.$key");
 
      print("subProcessDetailListBox.get ${subProcessDetailListBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getsubDomainDetailListener() {
    return Hive.box<String>(SubDomainDetailBox).listenable() ?? "";
  }

  ///// cousers data end
  static addCourseData(String courseListResponse) async {
    // final Box<List<CourseDetails>> courseListBox = await Hive.openBox<List<CourseDetails>>(CourseBox);
    courseListBox.put(CourseKey, courseListResponse);

    if (courseListBox.isNotEmpty) {
   
      print("courseListBox.get ${courseListBox.get(CourseKey)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getCourseListener() {
    return Hive.box<String>(CourseBox).listenable() ?? "";
  }

  static List<CourseDetails> getCourseDataList() {
    List<CourseDetails> storedCourseData = [];

    try {
      String courseData = courseListBox.get(CourseKey);
      // print(" >> courseData :  $courseData");
      List courselist = jsonDecode(courseData);

      storedCourseData = courselist.map((e) => CourseDetails.fromjson(e)).toList();
      // print(" >> couserList : $storedCourseData");

      // storedCourseData =
      print("storedCourseData list length ${storedCourseData.length}");
      return storedCourseData;
    } catch (e) {
      print("----- Exception Occured while getting getCourseDataList -----");
      print(e.toString());
      return storedCourseData;
    }
  }

  ///// cousers data end

  ////// master data start
  ///
  ///
  ///
  static setSubmitMockData(String mockId, String data) {
    submitDataBox.put(mockId, data);
    print("datata====>$data");
    if (submitDataBox.isNotEmpty) {
   
      print("submitDataBox.get for key: $mockId = ${submitDataBox.get(mockId)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static removeFromSubmitMockBox(String mockId) {
    // mockRestartBox.put(mockId, atemNum);

    if (mockNotSubmitBox.isNotEmpty) {
      if (mockNotSubmitBox.containsKey(mockId)) {
        mockNotSubmitBox.delete(mockId);
      }
      print("this is called and removed from box");
    } else {
      print("===========box is empty=========");
    }
  }

  static addToRestartBox(String mockId, RestartModel restartModel) {
    print("restart model answersMapp>>>${restartModel.answersMapp}");
    print("restart model quesNum>>>${restartModel.quesNum}");

    mockRestartBox.put(mockId, restartModel);

    if (mockRestartBox.isNotEmpty) {
     
      print("mockRestartBox.get for key: $mockId = ${mockRestartBox.get(mockId)}");
    } else {
      print("===========box is empty=========");
    }
  }


  // static addToRestartBox(String mockId, RestartModel restartModel) {
  //   print("restart model answersMapp>>>${restartModel.answersMapp}");
  //   print("restart model quesNum>>>${restartModel.quesNum}");

  //   mockRestartBox.put(mockId, restartModel);

  //   if (mockRestartBox.isNotEmpty) {
     
  //     print("mockRestartBox.get for key: $mockId = ${mockRestartBox.get(mockId)}");
  //   } else {
  //     print("===========box is empty=========");
  //   }
  // }


  static removeFromRestartBox(String mockId) {
    print("removing FromRestartBox");
    // mockRestartBox.put(mockId, atemNum);

    if (mockRestartBox.isNotEmpty) {
      print("mockRestartBox.isNotEmpty::::");
      if (mockRestartBox.containsKey(mockId)) {
        print("mockRestartBox.containsKey");
        print("deleting from the boxxxxx");
        mockRestartBox.delete(mockId);
      }
      print("mockRestartBox.get for key after deleted: $mockId = ${mockRestartBox.get(mockId)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static removeFromNotSubmitBox(String mockId) {
    // mockRestartBox.put(mockId, atemNum);

    if (mockRestartBox.isNotEmpty) {
      if (mockRestartBox.containsKey(mockId)) {
        mockRestartBox.delete(mockId);
      }
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<RestartModel>> getMockRestartListener() {
    return Hive.box<RestartModel>(MockRestartBoxKey).listenable();
  }


  static addMasterData(String masterListResponse, {String keyName}) async {
    masterListBox.put(keyName, masterListResponse);

    if (masterListBox.isNotEmpty) {
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getMasterListener() {
    return Hive.box<String>(MasterDataBox).listenable() ?? '';
  }

  static List<MasterDetails> getMasterDataList({String key}) {
    List<MasterDetails> storedMasterData = [];

    try {
      String masterData = masterListBox.get(key);
      // print(" >> courseData :  $masterData");
      List masterList = jsonDecode(masterData);

      storedMasterData = masterList.map((e) => MasterDetails.fromjson(e)).toList();
      print(" >> couserList : $storedMasterData");

      // storedCourseData =
      print("storedMasterData list length ${storedMasterData.length}");
      return storedMasterData;
    } catch (e) {
      print("----- Exception Occured while getting getMasterDataList -----");
      print(e.toString());
      return storedMasterData;
    }
  }


  static setFlashCateData({dynamic value, String Key}) async {
    await Hive.openBox(FlashCateBox);
    final box = Hive.box(FlashCateBox);
    print("incomimg valueeeeee=====>>>>$value");
    await box.put(Key, jsonEncode(value));
    try {
      print("get boxxxxx=======${box.get(Key, defaultValue: "")}");
    } catch (e) {
      print("errororor====$e");
    }
  }

  ///// master data end

  ///// mock test data start
  static addTestMpData(String mockTestsList, String keyName) async {
    TestPMListBox.put(keyName, mockTestsList);
    if (TestPMListBox.isNotEmpty) {

      print("testDataListBox.get Key: $keyName , Data: ${TestPMListBox.get(keyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getTestDataListener() {
    return Hive.box<String>(TestDataBox).listenable();
  }

  static List<TestDataDetails> getTestDataList({String key}) {
    List<TestDataDetails> storedTestData = [];

    try {
      String testData = TestPMListBox.get(key);
      print(" >> testData :  $testData");
      List testsList = jsonDecode(testData);

      storedTestData = testsList.map((e) => TestDataDetails.fromjson(e)).toList();
      print(" >> couserList : $storedTestData");

      // storedCourseData =
      print("storedCourseData list length ${storedTestData.length}");
      return storedTestData;
    } catch (e) {
      print("----- Exception Occured while getting getCourseDataList -----");
      print(e.toString());
      return storedTestData;
    }
  }

  ///// mock test data end

  static addFlashCateData(String flashCardData, String keyName) async {
    flashListCateBox.put(keyName, flashCardData);

    if (flashListCateBox.containsKey(keyName)) {
     
      print("flashCateListBox.get Key: $keyName  ,Data: ${flashListCateBox.get(keyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getFlashCateListener() {
    return Hive.box<String>(FlashCateBox).listenable() ?? "";
  }

  static List<FlashCateDetails> getFlashCateDataList({String key}) {
    try {
      // final List<FlashCateDetails> storedFlashCateData = flashListCateBox.get(key);
      // print("storedFlashCateData list length ${storedFlashCateData.length}");
      // return storedFlashCateData;
    } catch (e) {
      return [];
    }
  }

  static addNotSubmittedMock(String body, {String KeyName}) async {
    final Box<String> notSubmittedDataBox = await Hive.openBox<String>(notSubmitBox);
    notSubmittedDataBox.put(KeyName, body);
    if (notSubmittedDataBox.isNotEmpty) {
  
      print("notSubmittedDataBox.get${notSubmittedDataBox.get(KeyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static String getNotSubmittedMock({String keyName}) {
 
    try {
      final String storedNotSubmittedMock = mockNotSubmitBox.get(keyName);
   
      return storedNotSubmittedMock;
    } catch (e) {
      return "";
    }
  }

  static addFlash(List<FlashCardDetails> list, {String KeyName}) async {
    final Box<List<FlashCardDetails>> flashListBox = await Hive.openBox<List<FlashCardDetails>>(FlashCardBox);
    flashListBox.put(KeyName, list);
    if (flashListBox.isNotEmpty) {
    
      print("flashListBox.get${flashListBox.get(KeyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<List<FlashCardDetails>>> getFlashListener() {
    return Hive.box<List<FlashCardDetails>>(FlashCardBox).listenable();
  }

  static List<FlashCardDetails> getflashCardsList({String keyName}) {
    try {
      final List<FlashCardDetails> storedflash = flashListBox.get(keyName);
      print("storedCategories list length ${storedflash.length}");
      return storedflash;
    } catch (e) {
      return [];
    }
  }

  

  static setDeviceToken(String val) async {
    var _userBox = Hive.box(deviceTokenBox);
    await _userBox.put(deviceTokenKey, val);
  }

  static Future<String> getDeviceToken() async {
    var _userBox = Hive.box(deviceTokenBox);
    return _userBox.get(deviceTokenKey).toString();
  }

  static void clearUser() {
    var _userBox = Hive.box(userDataBox);
    _userBox.clear();
  }
}
