import 'package:flutter/material.dart';
import '../services/reminder_service.dart';
import 'add_buy_item_screen.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final ReminderService _service = ReminderService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_update);
  }

  @override
  void dispose() {
    _service.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final reminders = _service.buyReminders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Remind me to take it'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBuyItemScreen()),
          );
        },
        label: const Text('Adaugă'),
        icon: const Icon(Icons.add_shopping_cart),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: reminders.isEmpty
          ? const Center(
              child: Text(
                'Lista de cumpărături este goală.\nAdaugă un obiect și locația.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final item = reminders[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: item.isActive,
                      activeColor: Colors.blue,
                      onChanged: (val) {
                        _service.toggleBuyStatus(item.id);
                      },
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: item.isActive
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                        color: item.isActive ? Colors.black : Colors.grey,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 14, color: Colors.blueGrey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${item.locationName} (${item.distance} km)',
                                style: const TextStyle(color: Colors.blueGrey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Categorie: ${item.category}',
                          style:
                              const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          item.isActive ? 'Activ - Notificare la 200m' : 'Inactiv',
                          style: TextStyle(
                            color: item.isActive ? Colors.green : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _service.deleteBuyReminder(item.id);
                      },
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
