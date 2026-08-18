import 'package:flutter/material.dart';
import 'order.dart';
import 'add_order_page.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String getStatusText() {
    switch (widget.order.status) {
      case OrderStatus.newOrder:
        return 'Новый';
      case OrderStatus.inTransit:
        return 'В пути';
      case OrderStatus.delivered:
        return 'Доставлен';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Заказ ${widget.order.orderNumber}')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOrderPage(order: widget.order),
            ),
          );

          setState(() {});
        },
        icon: const Icon(Icons.edit),
        label: const Text('Редактировать'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Заказ ${widget.order.orderNumber}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            const Text('Адрес', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(widget.order.address),

            const SizedBox(height: 20),

            const Text(
              'Время доставки',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(widget.order.time),

            const SizedBox(height: 20),

            const Text('Статус', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),

            DropdownButton<OrderStatus>(
              value: widget.order.status,
              items: const [
                DropdownMenuItem(
                  value: OrderStatus.newOrder,
                  child: Text('Новый'),
                ),
                DropdownMenuItem(
                  value: OrderStatus.inTransit,
                  child: Text('В пути'),
                ),
                DropdownMenuItem(
                  value: OrderStatus.delivered,
                  child: Text('Доставлен'),
                ),
              ],
              onChanged: (OrderStatus? newStatus) {
                if (newStatus == null) {
                  return;
                }

                setState(() {
                  widget.order.status = newStatus;
                });
              },
            ),

            if (widget.order.comment.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Комментарий',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(widget.order.comment),
            ],
          ],
        ),
      ),
    );
  }
}
