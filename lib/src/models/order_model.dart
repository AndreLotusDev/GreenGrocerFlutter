import 'cart_item_model.dart';

class OrderModel {

  String id;
  DateTime orderCreationDt;
  DateTime overdueDt;
  List<CartItemModel>  items;
  String status;
  String copyAndPaste;
  double total;

  OrderModel({
    required this.id,
    required this.orderCreationDt,
    required this.overdueDt,
    required this.items,
    required this.status,
    required this.copyAndPaste,
    required this.total,
  });
}