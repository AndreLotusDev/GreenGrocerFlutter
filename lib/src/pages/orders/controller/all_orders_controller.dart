import 'package:get/get.dart';
import 'package:loja_virtual/src/models/order_model.dart';
import 'package:loja_virtual/src/pages/auth/controller/auth_controller.dart';
import 'package:loja_virtual/src/pages/orders/repository/orders_repository.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

class AllOrdersController extends GetxController {
  List<OrderModel> allOrders = [];
  final orderRepository = OrdersRepository();
  final authController = Get.find<AuthController>();
  final utilsService = UtilsServices();

  @override
  void onInit() {
    super.onInit();

    getAllOrders();
  }

  int getNumberOfOrders() {
    return allOrders.length;
  }

  OrderModel getOrderModelByIndex(int index) {
    return allOrders[index];
  }

  Future<void> getAllOrders() async {
    var result = await orderRepository.getAllOrders(
      userId: authController.user.id!,
      token: authController.user.token!,
    );

    result.when(
      success: (resultOrders) {
        allOrders.addAll(resultOrders);
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
