import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:http/http.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pgmp4u/Models/constants.dart';
import 'package:pgmp4u/Models/purchaseable_product.dart';
import 'package:pgmp4u/Models/store_state.dart';
import 'package:pgmp4u/Screens/home_view/home.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/purchase_interface.dart';
import 'package:pgmp4u/utils/event.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Models/apppurchasestatusmodel.dart';
import '../Services/globalcontext.dart';

abstract class PurchaseState extends ChangeNotifier {}

class Loading extends PurchaseState {}

class Success extends PurchaseState {}

class Default extends PurchaseState {
  String message; 

  Default({this.message});
}

class PurchaseProvider extends ChangeNotifier {
  ModelStatus latestStatus;
  
  bool loaderStatus=false;
  updatehere(bool val){
loaderStatus=val;
notifyListeners();
  }
 setStatus(ModelStatus val){
    latestStatus=val;
    notifyListeners();
 }
 ModelStatus getLatestStatus(){
    return latestStatus;
 }
//bool videoLibraryStatus=false;
  StoreState storeState = StoreState.loading;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<PurchasableProduct> products = [];

  bool get beautifiedDash => _beautifiedDashUpgrade;
  bool _beautifiedDashUpgrade = false;
  InAppPurchase iapConnection;

  Event<PurchaseState> serverResponse = Event(Default());

  PurchaseProvider() {
    if (Platform.isIOS) {
      iapConnection = InAppPurchase.instance;
      final purchaseUpdated = iapConnection.purchaseStream;
      _subscription = purchaseUpdated.listen(
        _onPurchaseUpdate,
        onDone: _updateStreamOnDone,
        onError: _updateStreamOnError,
      );
      loadPurchases();
    }
  }

  Future<void> loadPurchases() async {
    print("loadPurchase1");
    final available = await iapConnection.isAvailable();
    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }
    const ids = <String>{
      storeKeyConsumable,
      flashCards,videoLibraryLearningPrograms,
    };
    final response = await iapConnection.queryProductDetails(ids);
    //print("loadPurchases $storeKeyConsumable ${response.productDetails}");
    products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList();
    storeState = StoreState.available;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void showToast(context, message) {
    print("showToast => $message");
    if (message != null)
      Future.delayed(Duration.zero).then((value) {
        GFToast.showToast(
          message,
          context,
          toastPosition: GFToastPosition.BOTTOM,
        );
      });
  }

  Future<void> buy(PurchasableProduct product) async {
    final purchaseParam = PurchaseParam(productDetails: product.productDetails);

    print("start buy ");
    switch (product.id) {
      case storeKeyConsumable:
        var res =
            await iapConnection.buyConsumable(purchaseParam: purchaseParam);
           
        //print("apple payment status $res");
        break;
      case flashCards:
        var res =
            await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);

        //print("apple payment status $res");
        break;
      case videoLibraryLearningPrograms:
        var res =
            await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);

        //print("apple payment status $res");
        break;
      default:
        serverResponse =
            Event(Default(message: "${product.id} is not a known product"));

        throw ArgumentError.value(
            product.productDetails, '${product.id} is not a known product');
    }
  }

  restore() async {
    print("restore called");
    var result = await iapConnection.restorePurchases();
    print("restore result");
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(_handlePurchase);
    notifyListeners();
  }

  void _handlePurchase(PurchaseDetails purchaseDetails) {

    print("status of Listenersss>>>>>> ${purchaseDetails.status}");
    if(purchaseDetails.status == PurchaseStatus.pending){
     updatehere(true);
    }
    else{
      updatehere(false);
    }
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
          // print("receiptttt dataa ${purchaseDetails.verificationData.serverVerificationData}");
      switch (purchaseDetails.productID) {
        case storeKeyConsumable:
          paymentStatus(purchaseDetails.status,
              purchaseDetails.verificationData.serverVerificationData);
/*
          print("Purchased successfully \n Status => ${purchaseDetails.status};"
              "\n Error => ${purchaseDetails.error}"
              "\n Purchase Id => ${purchaseDetails.purchaseID}"
              "\n productID => ${purchaseDetails.productID}"
              "\n verificationData, localVerificationData => ${purchaseDetails.verificationData.localVerificationData}"
              "\n verificationData, serverVerificationData => ${purchaseDetails.verificationData.serverVerificationData}"
              "\n verificationData, source => ${purchaseDetails.verificationData.source}"
              "\n transactionDate => ${purchaseDetails.transactionDate}"
              "\n status => ${purchaseDetails.status}");*/
          break;
        case flashCards:
        handlestatusFlashCardAndVideoLib(purchaseDetails.status,
              purchaseDetails.verificationData.serverVerificationData,2);  // 2 for FLASH CARD
        //flashCardStatus=true;
        notifyListeners();
          // paymentStatus(purchaseDetails.status,
          //     purchaseDetails.verificationData.serverVerificationData);
          break;
        case videoLibraryLearningPrograms:
         handlestatusFlashCardAndVideoLib(purchaseDetails.status,
              purchaseDetails.verificationData.serverVerificationData,3);   // 3 FOR  VIDEO LIBRARY
        //videoLibraryStatus=true;
         notifyListeners();
        //  paymentStatus(purchaseDetails.status,
          //    purchaseDetails.verificationData.serverVerificationData);
          break;
      }
    }

    if (purchaseDetails.pendingCompletePurchase) {
      iapConnection.completePurchase(purchaseDetails);
    }
  }

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  Future paymentStatus(PurchaseStatus status, receiptData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    print("Token => $stringValue Purchase status $status");
    var request = json.encode({
      "payment_status":
          (status == PurchaseStatus.purchased) ? 'success' : status.toString(),
      "price": 1,
      "payment_receipt": receiptData,
      "payment_source": "app_store",
      "access_type": "life_time"
    });
    print("paymentStatus called => $status, $receiptData; request => $request");
    //return;

    serverResponse = Event(Loading());
    notifyListeners();

    response = await http.post(
      Uri.parse(IN_APP_PURCHASE),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': stringValue
      },
      body: request,
    );

    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      print("data => $data");
      if (data["success"] == true) {
        serverResponse = Event(Success());
      } else {
        print("Navigate back hit");
        serverResponse = Event(Default(message: data["message"]));
      }
    } else {
      serverResponse = Event(Default(message: response.body));
    }
    notifyListeners();
  }

Future handlestatusFlashCardAndVideoLib(PurchaseStatus status, receiptData,int planTyp)async{
SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    print("Token => $stringValue Purchase status $status");
      var request ={
      //= json.encode({

      "deviceType":"I",
      "planType":planTyp,
      "productId":planTyp==2 ?"flash_cards" : "video_recorded_learning_program",
      "payment_receipt":receiptData
    };
    //);
    //print("paymentStatus called => $status, $receiptData request => $request");

     response = await http.post(
      Uri.parse(InAppPurchasePaymentNew),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': stringValue
      },
      body: json.encode(request),
    );
     print(response.body);
     if(response.statusCode==200){
     updateStatusNew(isnav: true);
     }
}


  void _updateStreamOnError(dynamic error) {
    //Handle error here
  }

  

updateStatusNew({bool isnav=false})async{
  await updateStatusofPurchaseFLASHANDVIDEO(noNavigate: isnav);
}

Future updateStatusofPurchaseFLASHANDVIDEO({bool noNavigate=false}) async {
 
  Map mapResponse;
    print("Get Status of FlashCard  ${mapResponse}");
SharedPreferences prefs = await SharedPreferences.getInstance();

    // SharedPreferences prefs = await SharedPreferences.getInstance();
   String stringValue = prefs.getString('token');
   print(stringValue);
    http.Response response;
    response = await http.get(Uri.parse(checkStatusFlashAndVideo), headers: {
      'Content-Type': 'application/json',
      'Authorization': "Bearer "+stringValue
    });

    if (response.statusCode == 200) {
      print("Calling successfull");
      print(convert.jsonDecode(response.body));
     // setState(() {
        mapResponse = convert.jsonDecode(response.body);
        PurchaseProvider purchaseProvider = Provider.of(GlobalVariable.navState.currentContext,listen: false);
        print("datadatdtdatdatdasdtasdasdt>>>>>>>>>>$mapResponse");
        purchaseProvider.setStatus(ModelStatus.fromjson(mapResponse["data"]));
        latestStatus = purchaseProvider.getLatestStatus();
        print("real valuee of flash card status  ${latestStatus.flashCardStatus}");
        print("real valuee of video library status  ${latestStatus.videoLibStatus}");
        notifyListeners();
        if(Platform.isIOS&& noNavigate){
          Navigator.pop(GlobalVariable.navState.currentContext);
        }
    
     // });
      // print(convert.jsonDecode(response.body));
    }

}


  }