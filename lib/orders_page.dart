import 'package:flutter/material.dart';
import 'add_order_page.dart';
import 'order.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<Order> orders = [
    const Order(
      orderNumber: '№1001',
      address: 'ул. Ленина, 15',
      time: '14:00–16:00',
      comment: '',
    ),
    const Order(
      orderNumber: '№1002',
      address: 'ул. Гагарина, 8',
      time: '16:00–18:00',
      comment: '',
    ),
    const Order(
      orderNumber: '№1003',
      address: 'пр. Победы, 21',
      time: '18:00–20:00',
      comment: '',
    ),
  ];

  Future<void> addOrder() async {
    final newOrder = await Navigator.push<Order>(
      context,
      MaterialPageRoute(builder: (context) => const AddOrderPage()),
    );

    if (newOrder != null) {
      setState(() {
        orders.add(newOrder);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заказы')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return OrderCard(
            orderNumber: order.orderNumber,
            address: order.address,
            time: order.time,
            comment: order.comment,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addOrder,
        icon: const Icon(Icons.add),
        label: const Text('Добавить заказ'),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String address;
  final String time;
  final String comment;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.address,
    required this.time,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final commentText = comment.isEmpty ? '' : '\n$comment';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.local_shipping)),
        title: Text(
          'Заказ $orderNumber',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$address\n$time$commentText'),
        isThreeLine: comment.isNotEmpty,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
