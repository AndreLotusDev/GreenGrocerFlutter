import 'package:get/get.dart';
import 'package:loja_virtual/src/models/order_model.dart';
import 'package:loja_virtual/src/pages/auth/controller/auth_controller.dart';
import 'package:loja_virtual/src/pages/orders/repository/orders_repository.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

class OrderController extends GetxController {
  final orderRepository = OrdersRepository();
  final authController = Get.find<AuthController>();
  final utilsService = UtilsServices();
  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  OrderModel order;

  OrderController(this.order);

  Future<void> getOrderItems() async {
    setLoading(true);

    var result = await orderRepository.getOrderItems(
      orderId: order.id,
      token: authController.user.token!,
    );

    setLoading(false);

    result.when(
      success: (items) {
        order.items.addAll(items);
        update();
      },
      error: (message) {
        utilsService.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
