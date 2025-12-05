import 'package:flutter/material.dart';
import '../models/reminder.dart';

// A simple service to hold state in memory for the session
class ReminderService extends ChangeNotifier {
  static final ReminderService _instance = ReminderService._internal();
  factory ReminderService() => _instance;
  ReminderService._internal();

  final List<Reminder> _leaveReminders = [];
  final List<Reminder> _buyReminders = [];

  List<Reminder> get leaveReminders => _leaveReminders;
  List<Reminder> get buyReminders => _buyReminders;

  void addLeaveReminder(String title) {
    _leaveReminders.add(Reminder(
      id: DateTime.now().toString(),
      title: title,
    ));
    notifyListeners();
  }

  void addBuyReminder(String title, String locationName, String category, double distance) {
    _buyReminders.add(Reminder(
      id: DateTime.now().toString(),
      title: title,
      locationName: locationName,
      category: category,
      distance: distance,
    ));
    notifyListeners();
  }

  void toggleLeaveStatus(String id) {
    final index = _leaveReminders.indexWhere((element) => element.id == id);
    if (index != -1) {
      _leaveReminders[index].isActive = !_leaveReminders[index].isActive;
      notifyListeners();
    }
  }

  void toggleBuyStatus(String id) {
    final index = _buyReminders.indexWhere((element) => element.id == id);
    if (index != -1) {
      _buyReminders[index].isActive = !_buyReminders[index].isActive;
      notifyListeners();
    }
  }

  void deleteLeaveReminder(String id) {
    _leaveReminders.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void deleteBuyReminder(String id) {
    _buyReminders.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
