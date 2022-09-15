import 'package:loja_virtual/src/constants/endpoints.dart';
import 'package:loja_virtual/src/models/cart_item_model.dart';
import 'package:loja_virtual/src/models/order_model.dart';
import 'package:loja_virtual/src/pages/cart/cart_result/cart_result.dart';
import 'package:loja_virtual/src/services/http_manager.dart';

class CartRepository {
  final _httpManager = HttpManager();

  Future<CartResult<List<CartItemModel>>> getCartItems({
    required String token,
    required String userId,
  }) async {
    var result = await _httpManager.restRequest(
      url: Endpoints.getCartItems,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'user': userId,
      },
    );

    if (result['result'] != null) {
      List<CartItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(CartItemModel.fromJson)
              .toList();

      return CartResult<List<CartItemModel>>.success(data);
    } else {
      return CartResult.error(
          'Houve um erro ao recuperar os itens do carrinho');
    }
  }

  Future<CartResult<OrderModel>> cartCheckout(
      {required String token, required double total}) async {
    var result = await _httpManager.restRequest(
      url: Endpoints.checkout,
      method: HttpMethods.post,
      body: {
        'total': total,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    if (result['result'] != null) {
      var order = OrderModel.fromJson(result['result']);

      return CartResult.success(order);
    } else {
      return CartResult.error('Houve um erro ao finalizar o pedido!');
    }
  }

  Future<bool> changeItemQuantity({
    required String token,
    required String cartItemId,
    required int quantity,
  }) async {
    var result = await _httpManager.restRequest(
      url: Endpoints.modifyItemsQuantity,
      method: HttpMethods.post,
      body: {'cartItemId': cartItemId, 'quantity': quantity},
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    if (result.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<CartResult<String>> addItemToCart({
    required String userId,
    required String token,
    required String productId,
    required int quantity,
  }) async {
    var result = await _httpManager.restRequest(
      url: Endpoints.addItemToCart,
      method: HttpMethods.post,
      body: {
        'user': userId,
        'quantity': 1,
        'productId': productId,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    if (result['result'] != null) {
      return CartResult<String>.success(result['result']['id']);
    } else {
      return CartResult.error('Não foi possível adicionar item no carrinho');
    }
  }
}
