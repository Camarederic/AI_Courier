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

  String _formatCreatedAt(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day.$month.$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Заказ ${widget.order.orderNumber}')),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOrderPage(order: widget.order),
                ),
              );

              if (!mounted) {
                return;
              }

              setState(() {});
            },
            icon: const Icon(Icons.edit),
            label: const Text('Редактировать'),
          ),

          const SizedBox(height: 12),

          FloatingActionButton.extended(
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Удалить заказ?'),
                    content: Text(
                      'Вы действительно хотите удалить заказ '
                      '${widget.order.orderNumber}?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Удалить'),
                      ),
                    ],
                  );
                },
              );

              if (shouldDelete == true) {
                if (!context.mounted) {
                  return;
                }

                Navigator.pop(context, true);
              }
            },
            icon: const Icon(Icons.delete),
            label: const Text('Удалить'),
          ),
        ],
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

            const Text('Создан', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(_formatCreatedAt(widget.order.createdAt)),

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
