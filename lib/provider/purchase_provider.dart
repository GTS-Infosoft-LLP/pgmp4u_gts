import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pgmp4u/Models/constants.dart';
import 'package:pgmp4u/Models/purchaseable_product.dart';
import 'package:pgmp4u/Models/store_state.dart';

class PurchaseProvider extends ChangeNotifier {
  StoreState storeState = StoreState.loading;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<PurchasableProduct> products = [];

  bool get beautifiedDash => _beautifiedDashUpgrade;
  bool _beautifiedDashUpgrade = false;
  final iapConnection = InAppPurchase.instance;

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

  Future<void> buy(PurchasableProduct product) async {
    final purchaseParam = PurchaseParam(productDetails: product.productDetails);
    switch (product.id) {
      case storeKeyConsumable:
        await iapConnection.buyConsumable(purchaseParam: purchaseParam);
        break;
      default:
        throw ArgumentError.value(
            product.productDetails, '${product.id} is not a known product');
    }
  }

  restore() async {
    print("restore called");
    var result = await iapConnection.restorePurchases(applicationUserName: "testin");
    print("restore result");
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(_handlePurchase);
    notifyListeners();
  }

  void _handlePurchase(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
      switch (purchaseDetails.productID) {
        case storeKeyConsumable:
          print("Purchased successfully \n Status => ${purchaseDetails.status};"
              "\n Error => ${purchaseDetails.error}"
              "\n Purchase Id => ${purchaseDetails.purchaseID}"
              "\n productID => ${purchaseDetails.productID}"
              "\n verificationData, localVerificationData => ${purchaseDetails.verificationData.localVerificationData}"
              "\n verificationData, serverVerificationData => ${purchaseDetails.verificationData.serverVerificationData}"
              "\n verificationData, source => ${purchaseDetails.verificationData.source}"
              "\n transactionDate => ${purchaseDetails.transactionDate}"
              "\n status => ${purchaseDetails.status}"
              "");
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

  void _updateStreamOnError(dynamic error) {
    //Handle error here
  }
}
