import 'package:flutter/material.dart';
import 'order.dart';

class AddOrderPage extends StatefulWidget {
  final Order? order;

  const AddOrderPage({super.key, this.order});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final addressController = TextEditingController();
  final timeController = TextEditingController();
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.order != null) {
      addressController.text = widget.order!.address;
      timeController.text = widget.order!.time;
      commentController.text = widget.order!.comment;
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    timeController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.order == null ? 'Добавить заказ' : 'Редактировать заказ',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Адрес доставки',
                hintText: 'Например: ул. Ленина, 15',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Время доставки',
                hintText: 'Например: 14:00–16:00',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Комментарий',
                hintText: 'Дополнительная информация',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.comment),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Введите адрес доставки')),
                    );
                    return;
                  }

                  if (widget.order != null) {
                    widget.order!.address = addressController.text.trim();
                    widget.order!.time = timeController.text.trim();
                    widget.order!.comment = commentController.text.trim();

                    Navigator.pop(context);
                  } else {
                    final newOrder = Order(
                      orderNumber: '№${1004}',
                      address: addressController.text.trim(),
                      time: timeController.text.trim(),
                      comment: commentController.text.trim(),
                    );

                    Navigator.pop(context, newOrder);
                  }
                },
                icon: Icon(widget.order == null ? Icons.check : Icons.save),
                label: Text(
                  widget.order == null
                      ? 'Создать заказ'
                      : 'Сохранить изменения',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
