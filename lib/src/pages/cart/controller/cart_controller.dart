import 'package:get/get.dart';
import 'package:loja_virtual/src/models/item_model.dart';
import 'package:loja_virtual/src/pages/auth/controller/auth_controller.dart';
import 'package:loja_virtual/src/pages/cart/repository/cart_repository.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

import '../../../models/cart_item_model.dart';

class CartController extends GetxController {
  final _cartRepository = CartRepository();
  final _authController = Get.find<AuthController>();

  final _utilsServices = UtilsServices();

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

    return response;
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

      var resultChangeOfQuantity = await changeItemQuantity(
        item: product,
        quantity: product.quantity + quantity,
      );

      if (resultChangeOfQuantity) {
        cartItems[itemIndex].quantity += quantity;
      } else {
        _utilsServices.showToast(
          message: 'Ocorreu um erro ao alterar a quantidade do produto',
          isError: true,
        );
      }
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
