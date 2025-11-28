import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';

class CartModel extends Equatable {
  final int? id;
  final int productId;
  final int quantity;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CartModel({
    this.id,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    this.updatedAt,
  });

  factory CartModel.fromDrift(CartTableData row) {
    return CartModel(
      id: row.id,
      productId: row.productId,
      quantity: row.quantity,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  CartTableCompanion toCompanion() {
    return CartTableCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      productId: Value(productId),
      quantity: Value(quantity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  CartModel copyWith({
    int? id,
    int? productId,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        quantity,
        createdAt,
        updatedAt,
      ];
}