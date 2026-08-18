import 'package:flutter/material.dart';
import 'add_order_page.dart';
import 'order.dart';
import 'order_details_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<Order> orders = [
    Order(
      orderNumber: '№1001',
      address: 'ул. Ленина, 15',
      time: '14:00–16:00',
      comment: '',
    ),
    Order(
      orderNumber: '№1002',
      address: 'ул. Гагарина, 8',
      time: '16:00–18:00',
      comment: '',
    ),
    Order(
      orderNumber: '№1003',
      address: 'пр. Победы, 21',
      time: '18:00–20:00',
      comment: '',
    ),
  ];

  final searchController = TextEditingController();
  OrderStatus? selectedStatus;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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

  List<Order> get filteredOrders {
    final query = searchController.text.toLowerCase().trim();

    return orders.where((order) {
      final matchesSearch =
          order.orderNumber.toLowerCase().contains(query) ||
          order.address.toLowerCase().contains(query) ||
          order.comment.toLowerCase().contains(query);

      final matchesStatus =
          selectedStatus == null || order.status == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заказы')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Поиск заказа',
                hintText: 'Номер, адрес или комментарий',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<OrderStatus?>(
              initialValue: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Фильтр по статусу',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem<OrderStatus?>(value: null, child: Text('Все')),
                DropdownMenuItem<OrderStatus?>(
                  value: OrderStatus.newOrder,
                  child: Text('Новые'),
                ),
                DropdownMenuItem<OrderStatus?>(
                  value: OrderStatus.inTransit,
                  child: Text('В пути'),
                ),
                DropdownMenuItem<OrderStatus?>(
                  value: OrderStatus.delivered,
                  child: Text('Доставлены'),
                ),
              ],
              onChanged: (OrderStatus? value) {
                setState(() {
                  selectedStatus = value;
                });
              },
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(
                    child: Text(
                      '🔍 Заказы не найдены',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];

                      return OrderCard(
                        orderNumber: order.orderNumber,
                        address: order.address,
                        time: order.time,
                        comment: order.comment,
                        status: order.status,
                        onTap: () async {
                          final shouldDelete = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsPage(order: order),
                            ),
                          );

                          if (shouldDelete == true) {
                            setState(() {
                              orders.remove(order);
                            });
                          } else {
                            setState(() {});
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
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
  final OrderStatus status;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.address,
    required this.time,
    required this.comment,
    required this.status,
    required this.onTap,
  });

  String getStatusText() {
    switch (status) {
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
    final commentText = comment.isEmpty ? '' : '\n$comment';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(child: Icon(Icons.local_shipping)),
        title: Text(
          'Заказ $orderNumber',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$address\n$time$commentText'),
        isThreeLine: comment.isNotEmpty,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              getStatusText(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
