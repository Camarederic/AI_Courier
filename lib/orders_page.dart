import 'package:flutter/material.dart';
import 'add_order_page.dart';
import 'order.dart';
import 'order_details_page.dart';
import 'order_storage.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<Order> orders = [];

  final searchController = TextEditingController();

  OrderStatus? selectedStatus;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final savedOrders = await OrderStorage.loadOrders();

    if (!mounted) {
      return;
    }

    setState(() {
      orders.addAll(savedOrders);
      _isLoading = false;
    });
  }

  Future<void> _saveOrders() async {
    await OrderStorage.saveOrders(orders);
  }

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

      await _saveOrders();
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Заказы')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                        createdAt: order.createdAt,
                        onTap: () async {
                          final shouldDelete = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsPage(order: order),
                            ),
                          );

                          if (!mounted) {
                            return;
                          }

                          if (shouldDelete == true) {
                            setState(() {
                              orders.remove(order);
                            });

                            await _saveOrders();
                          } else {
                            setState(() {});
                            await _saveOrders();
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
  final DateTime createdAt;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.address,
    required this.time,
    required this.comment,
    required this.status,
    required this.createdAt,
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

  String _formatCreatedAt() {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year.toString();

    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');

    return '$day.$month.$year $hour:$minute';
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
        subtitle: Text(
          '$address\n$time\nСоздан: ${_formatCreatedAt()}$commentText',
        ),
        isThreeLine: true,
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
