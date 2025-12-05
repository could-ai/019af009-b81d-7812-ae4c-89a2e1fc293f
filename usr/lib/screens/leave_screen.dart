import 'package:flutter/material.dart';
import '../services/reminder_service.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final TextEditingController _controller = TextEditingController();
  final ReminderService _service = ReminderService();

  @override
  void initState() {
    super.initState();
    // Listen to changes in service
    _service.addListener(_update);
  }

  @override
  void dispose() {
    _service.removeListener(_update);
    _controller.dispose();
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      _service.addLeaveReminder(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminders = _service.leaveReminders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Remind me when I leave'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ex: Portofel, Chei...',
                      border: OutlineInputBorder(),
                      labelText: 'Adaugă obiect',
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  style: IconButton.styleFrom(backgroundColor: Colors.orange),
                )
              ],
            ),
          ),
          Expanded(
            child: reminders.isEmpty
                ? const Center(
                    child: Text(
                      'Lista este goală.\nAdaugă lucruri de luat când pleci.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final item = reminders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isActive,
                            activeColor: Colors.orange,
                            onChanged: (val) {
                              _service.toggleLeaveStatus(item.id);
                            },
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              decoration: item.isActive
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                              color: item.isActive ? Colors.black : Colors.grey,
                            ),
                          ),
                          subtitle: Text(
                            item.isActive ? 'Activ' : 'Inactiv',
                            style: TextStyle(
                              color: item.isActive ? Colors.green : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _service.deleteLeaveReminder(item.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
