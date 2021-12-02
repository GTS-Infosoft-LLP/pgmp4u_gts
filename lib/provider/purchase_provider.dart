import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pgmp4u/Models/constants.dart';
import 'package:pgmp4u/Models/purchaseable_product.dart';
import 'package:pgmp4u/Models/store_state.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/purchase_interface.dart';
import 'package:pgmp4u/utils/event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class PurchaseState extends ChangeNotifier {}

class Loading extends PurchaseState {}

class Success extends PurchaseState {}

class Default extends PurchaseState {
  String message;

  Default({this.message});
}

class PurchaseProvider extends ChangeNotifier {
  StoreState storeState = StoreState.loading;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<PurchasableProduct> products = [];

  bool get beautifiedDash => _beautifiedDashUpgrade;
  bool _beautifiedDashUpgrade = false;
  final iapConnection = InAppPurchase.instance;

  Event<PurchaseState> serverResponse = Event(Default());

  PurchaseProvider() {
    final purchaseUpdated = iapConnection.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    print("loadPurchase");
    final available = await iapConnection.isAvailable();
    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }
    const ids = <String>{
      storeKeyConsumable,
    };
    final response = await iapConnection.queryProductDetails(ids);
    print("loadPurchases $storeKeyConsumable ${response.productDetails}");
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
    switch (product.id) {
      case storeKeyConsumable:
        await iapConnection.buyConsumable(purchaseParam: purchaseParam);
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
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
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
    print(
        "Token => $stringValue Purchase status ${status == PurchaseStatus.purchased}");
    var request = json.encode({
      "payment_status":
          (status == PurchaseStatus.purchased) ? 'success' : status,
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
      Map<String,dynamic> data = json.decode(response.body);
      if(data["status"] == true) {
        serverResponse = Event(Success());
      }else{
        print("Navigate back hit");
        serverResponse = Event(Default(message: data["message"]));
      }
    } else {
      serverResponse = Event(Default(message: response.body));
    }
    notifyListeners();
  }

  void _updateStreamOnError(dynamic error) {
    //Handle error here
  }
}
