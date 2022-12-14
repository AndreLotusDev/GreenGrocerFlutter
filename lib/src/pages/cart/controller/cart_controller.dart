import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/src/models/item_model.dart';
import 'package:loja_virtual/src/pages/auth/controller/auth_controller.dart';
import 'package:loja_virtual/src/pages/cart/repository/cart_repository.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

import '../../../models/cart_item_model.dart';
import '../../common_widgets/payment_dialog.dart';

class CartController extends GetxController {
  final _cartRepository = CartRepository();
  final _authController = Get.find<AuthController>();

  final _utilsServices = UtilsServices();

  bool isCheckoutLoading = false;
  void setCheckoutLoading(bool actualStatus) {
    isCheckoutLoading = actualStatus;
    update();
  }

  List<CartItemModel> cartItems = [];

  int getCartItemsLength() {
    return cartItems.length;
  }

  @override
  void onInit() {
    super.onInit();

    getCartItems();
  }

  Future<bool> changeItemQuantity({
    required CartItemModel item,
    required int quantity,
  }) async {
    var response = await _cartRepository.changeItemQuantity(
      token: _authController.user.token!,
      cartItemId: item.id,
      quantity: quantity,
    );

    if (response) {
      if (quantity == 0) {
        cartItems.removeWhere((cartItem) => cartItem.id == item.id);
      } else {
        var itemFound =
            cartItems.firstWhere((cartItem) => cartItem.id == item.id);
        itemFound.quantity = quantity;
      }

      update();
    } else {
      _utilsServices.showToast(
        message: 'Ocorreu um erro ao modificar os items do carrinho',
        isError: true,
      );
    }

    return response;
  }

  Future checkoutCart() async {
    setCheckoutLoading(true);

    var cartResult = await _cartRepository.cartCheckout(
      token: _authController.user.token!,
      total: cartTotalPrice(),
    );

    setCheckoutLoading(false);

    cartResult.when(
      success: (cartModel) {
        cartItems.clear();
        update();

        showDialog(
          context: Get.context!,
          builder: (_) {
            return PaymentDialog(
              order: cartModel,
            );
          },
        );
      },
      error: (messageError) {
        _utilsServices.showToast(
          message: messageError,
          isError: true,
        );
      },
    );
  }

  double cartTotalPrice() {
    double total = 0;

    for (final item in cartItems) {
      total += item.totalPrice();
    }

    return total;
  }

  Future<void> getCartItems() async {
    if (_authController.user.token == null ||
        _authController.user.token == '') {
      return;
    }

    var result = await _cartRepository.getCartItems(
      token: _authController.user.token!,
      userId: _authController.user.id!,
    );

    result.when(
      success: (cartItemsBackend) {
        cartItems.addAll(cartItemsBackend);
        update();
      },
      error: (message) {
        _utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  int getItemIndex(ItemModel item) {
    return cartItems.indexWhere((itemInList) => itemInList.item.id == item.id);
  }

  Future<void> addItemToCart(
      {required ItemModel item, int quantity = 1}) async {
    int itemIndex = getItemIndex(item);

    var productAlreadyExists = itemIndex >= 0;
    if (productAlreadyExists) {
      final product = cartItems[itemIndex];

      await changeItemQuantity(
        item: product,
        quantity: product.quantity + quantity,
      );
    } else {
      var result = await _cartRepository.addItemToCart(
        userId: _authController.user.id!,
        token: _authController.user.token!,
        productId: item.id,
        quantity: quantity,
      );

      result.when(
        success: (cartItemId) {
          cartItems.add(
            CartItemModel(
              item: item,
              quantity: quantity,
              id: cartItemId,
            ),
          );
        },
        error: (e) {
          _utilsServices.showToast(
            message: e,
            isError: true,
          );
        },
      );
    }

    update();
  }
}
