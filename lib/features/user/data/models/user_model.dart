import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';

class UserModel extends Equatable {
  final int? id;
  final String name;
  final String phone;
  final String address;
  final String role;

  const UserModel({
    this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.role,
  });

  factory UserModel.fromDrift(UserTableData row) {
    return UserModel(
      id: row.id,
      name: row.name,
      phone: row.phone,
      address: row.address,
      role: row.role,
    );
  }

  UserTableCompanion toCompanion() {
    return UserTableCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      role: Value(role),
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        address,
        role,
      ];
}

