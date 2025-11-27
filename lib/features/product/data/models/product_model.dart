import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';

class ProductModel extends Equatable {
  final int? id;
  final String name;
  final int price;
  final int stock;
  final String? thumbnail;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.thumbnail,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromDrift(ProductTableData row) {
    return ProductModel(
      id: row.id,
      name: row.name,
      price: row.price,
      stock: row.stock,
      thumbnail: row.thumbnail,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  ProductTableCompanion toCompanion() {
    return ProductTableCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      name: Value(name),
      price: Value(price),
      stock: Value(stock),
      thumbnail: Value(thumbnail),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    int? price,
    int? stock,
    String? thumbnail,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      thumbnail: thumbnail ?? this.thumbnail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        stock,
        thumbnail,
        createdAt,
        updatedAt,
      ];
}
