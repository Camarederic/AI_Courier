import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'order.dart';

class OrderStorage {
  static const String _ordersKey = 'orders';

  static Future<void> saveOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();

    final ordersJson = orders.map((order) {
      return {
        'orderNumber': order.orderNumber,
        'address': order.address,
        'time': order.time,
        'comment': order.comment,
        'status': order.status.name,
      };
    }).toList();

    await prefs.setString(_ordersKey, jsonEncode(ordersJson));
  }

  static Future<List<Order>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_ordersKey);

    if (data == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(data);

    return decoded.map((item) {
      return Order(
        orderNumber: item['orderNumber'],
        address: item['address'],
        time: item['time'],
        comment: item['comment'],
        status: OrderStatus.values.firstWhere(
          (status) => status.name == item['status'],
          orElse: () => OrderStatus.newOrder,
        ),
      );
    }).toList();
  }
}
