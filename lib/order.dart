enum OrderStatus { newOrder, inTransit, delivered }

class Order {
  final String orderNumber;
  final String address;
  final String time;
  final String comment;
  OrderStatus status;

  Order({
    required this.orderNumber,
    required this.address,
    required this.time,
    required this.comment,
    this.status = OrderStatus.newOrder,
  });
}
