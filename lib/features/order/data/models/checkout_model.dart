import 'package:toko_online_sederhana/features/cart/data/models/cart_model.dart';
import 'package:toko_online_sederhana/features/user/data/models/user_model.dart';

class CheckoutData {
  final UserModel user;
  final List<CartModel> items;

  CheckoutData({
    required this.user,
    required this.items,
  });
}
