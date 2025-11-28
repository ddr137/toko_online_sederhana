import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';

class OrderModel extends Equatable {
  final int? id;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String shippingAddress;
  final int totalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const OrderModel({
    this.id,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.shippingAddress,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromDrift(OrderTableData row) {
    return OrderModel(
      id: row.id,
      customerName: row.customerName,
      customerEmail: row.customerEmail,
      customerPhone: row.customerPhone,
      shippingAddress: row.shippingAddress,
      totalPrice: row.totalPrice,
      status: row.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  OrderTableCompanion toCompanion() {
    return OrderTableCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      customerName: Value(customerName),
      customerEmail: Value(customerEmail),
      customerPhone: Value(customerPhone),
      shippingAddress: Value(shippingAddress),
      totalPrice: Value(totalPrice),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  OrderModel copyWith({
    int? id,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? shippingAddress,
    int? totalPrice,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerName,
        customerEmail,
        customerPhone,
        shippingAddress,
        totalPrice,
        status,
        createdAt,
        updatedAt,
      ];
}