enum OrderStatus { newOrder, inTransit, delivered }

class Order {
  final String orderNumber;
  String address;
  String time;
  String comment;
  OrderStatus status;

  // Дата и время создания заказа.
  final DateTime createdAt;

  Order({
    required this.orderNumber,
    required this.address,
    required this.time,
    required this.comment,
    required this.createdAt,
    this.status = OrderStatus.newOrder,
  });

  // Превращаем заказ в данные для сохранения.
  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'address': address,
      'time': time,
      'comment': comment,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Восстанавливаем заказ из сохранённых данных.
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderNumber: json['orderNumber'] as String,
      address: json['address'] as String,
      time: json['time'] as String,
      comment: json['comment'] as String,
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => OrderStatus.newOrder,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
