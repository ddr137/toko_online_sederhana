import 'package:toko_online_sederhana/features/cart/data/models/cart_model.dart';
import 'package:toko_online_sederhana/features/product/data/models/product_model.dart';
import 'package:toko_online_sederhana/features/user/data/models/user_model.dart';

class CheckoutData {
  final UserModel user;
  final List<CheckoutItem> items;

  CheckoutData({required this.user, required this.items});
}

class CheckoutItem {
  final ProductModel product;
  final CartModel cart;

  CheckoutItem({required this.product, required this.cart});
}

