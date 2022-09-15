import 'package:loja_virtual/src/constants/endpoints.dart';
import 'package:loja_virtual/src/models/cart_item_model.dart';
import 'package:loja_virtual/src/models/order_model.dart';
import 'package:loja_virtual/src/pages/orders/order_result/orders_result.dart';
import 'package:loja_virtual/src/services/http_manager.dart';

class OrdersRepository {
  final _httpmanager = HttpManager();

  Future<OrdersResult<List<OrderModel>>> getAllOrders(
      {required String userId, required String token}) async {
    final result = await _httpmanager.restRequest(
      url: Endpoints.getAllOrders,
      method: HttpMethods.post,
      body: {'user': userId},
      headers: {'X-Parse-Session-Token': token},
    );

    if (result['result'] != null) {
      var orders = List<Map<String, dynamic>>.from(result['result'])
          .map(OrderModel.fromJson)
          .toList();

      return OrdersResult.success(orders);
    } else {
      return OrdersResult.error('Não foi possível recuperar os pedidos');
    }
  }

  Future<OrdersResult<List<CartItemModel>>> getOrderItems(
      {required String orderId, required String token}) async {
    var result = await _httpmanager.restRequest(
      url: Endpoints.getOrderItems,
      method: HttpMethods.post,
      body: {
        'orderId': orderId,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    if (result['result'] != null) {
      var items = List<Map<String, dynamic>>.from(result['result'])
          .map(CartItemModel.fromJson)
          .toList();

      return OrdersResult.success(items);
    } else {
      return OrdersResult.error(
          'Não foi possível recuperar os items do pedido');
    }
  }
}
