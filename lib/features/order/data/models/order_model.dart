import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_item_model.dart';

class OrderModel extends Equatable {
  final int? id;
  final String customerName;
  final String customerRole;
  final String customerPhone;
  final String shippingAddress;
  final int totalPrice;
  final String status;
  final String? paymentProofPath;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<OrderItemModel>? items;

  const OrderModel({
    this.id,
    required this.customerName,
    required this.customerRole,
    required this.customerPhone,
    required this.shippingAddress,
    required this.totalPrice,
    required this.status,
    this.paymentProofPath,
    required this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory OrderModel.fromDrift(
    OrderTableData row, {
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: row.id,
      customerName: row.customerName,
      customerRole: row.customerRole,
      customerPhone: row.customerPhone,
      shippingAddress: row.shippingAddress,
      totalPrice: row.totalPrice,
      status: row.status,
      paymentProofPath: row.paymentProofPath,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      items: items,
    );
  }

  OrderTableCompanion toCompanion() {
    return OrderTableCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      customerName: Value(customerName),
      customerRole: Value(customerRole),
      customerPhone: Value(customerPhone),
      shippingAddress: Value(shippingAddress),
      totalPrice: Value(totalPrice),
      status: Value(status),
      paymentProofPath: Value(paymentProofPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  OrderModel copyWith({
    int? id,
    String? customerName,
    String? customerRole,
    String? customerPhone,
    String? shippingAddress,
    int? totalPrice,
    String? status,
    String? paymentProofPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerRole: customerRole ?? this.customerRole,
      customerPhone: customerPhone ?? this.customerPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentProofPath: paymentProofPath ?? this.paymentProofPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    id,
    customerName,
    customerRole,
    customerPhone,
    shippingAddress,
    totalPrice,
    status,
    paymentProofPath,
    createdAt,
    updatedAt,
    items,
  ];
}

