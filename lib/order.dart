enum OrderStatus { newOrder, inTransit, delivered }

class Order {
  final String orderNumber;
  String address;
  String time;
  String comment;
  OrderStatus status;

  Order({
    required this.orderNumber,
    required this.address,
    required this.time,
    required this.comment,
    this.status = OrderStatus.newOrder,
  });
}
