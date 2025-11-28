import 'package:equatable/equatable.dart';

class OrderItemModel extends Equatable {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final int price;
  final String productName;
  final String? productImage;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
    this.productImage,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    productId,
    quantity,
    price,
    productName,
    productImage,
  ];
}

