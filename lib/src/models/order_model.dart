import 'package:json_annotation/json_annotation.dart';

import 'cart_item_model.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  String id;
  @JsonKey(name: 'createdAt')
  DateTime? createdDateTime;
  @JsonKey(name: 'due')
  DateTime overdueDt;
  @JsonKey(defaultValue: [])
  List<CartItemModel> items;
  String status;
  @JsonKey(name: 'copiaecola')
  String copyAndPaste;
  double total;

  String qrCodeImage;

  bool get isOverDue => overdueDt.isBefore(DateTime.now());

  OrderModel({
    required this.id,
    required this.createdDateTime,
    required this.overdueDt,
    required this.items,
    required this.status,
    required this.copyAndPaste,
    required this.total,
    this.qrCodeImage = '',
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
