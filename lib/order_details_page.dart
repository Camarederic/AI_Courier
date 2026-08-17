import 'package:flutter/material.dart';
import 'order.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Заказ ${order.orderNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Заказ ${order.orderNumber}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            const Text('Адрес', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(order.address),

            const SizedBox(height: 20),

            const Text(
              'Время доставки',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(order.time),

            if (order.comment.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Комментарий',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(order.comment),
            ],
          ],
        ),
      ),
    );
  }
}
