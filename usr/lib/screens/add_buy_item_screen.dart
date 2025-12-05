import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/reminder.dart';
import '../services/reminder_service.dart';

class AddBuyItemScreen extends StatefulWidget {
  const AddBuyItemScreen({super.key});

  @override
  State<AddBuyItemScreen> createState() => _AddBuyItemScreenState();
}

class _AddBuyItemScreenState extends State<AddBuyItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  
  String? _selectedCategory;
  Store? _selectedStore;
  List<Store> _availableStores = [];
  bool _isSearching = false;

  final List<String> _categories = [
    'Magazin de bricolaj',
    'Magazin de mobila',
    'Farmacie',
    'Magazin de alimente',
  ];

  void _onCategoryChanged(String? newValue) {
    setState(() {
      _selectedCategory = newValue;
      _selectedStore = null;
      _searchController.clear();
      if (newValue != null) {
        _availableStores = MockData.getStoresByCategory(newValue);
        // Sort: closest first
        _availableStores.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      } else {
        _availableStores = [];
      }
    });
  }

  void _onSearch(String query) {
    if (query.isEmpty) return;
    setState(() {
      _isSearching = true;
      _selectedCategory = null; // Clear category if searching manually
      _selectedStore = null;
      _availableStores = MockData.searchStores(query);
      _isSearching = false;
    });
  }

  void _saveReminder() {
    if (_formKey.currentState!.validate() && _selectedStore != null) {
      ReminderService().addBuyReminder(
        _itemController.text,
        _selectedStore!.name,
        _selectedCategory ?? 'Căutare directă',
        _selectedStore!.distanceKm,
      );
      Navigator.pop(context);
    } else if (_selectedStore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te rog alege un magazin din listă.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaugă obiect de cumpărat'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Item Name
              TextFormField(
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'Ce dorești să cumperi?',
                  hintText: 'Ex: Ciocan, Lapte, Scaun...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Te rog introdu numele obiectului';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Unde găsești acest produs?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 2. Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Alege categoria (încarcă magazine pe 10km)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: _onCategoryChanged,
              ),

              const SizedBox(height: 10),
              const Center(child: Text('- SAU -', style: TextStyle(color: Colors.grey))),
              const SizedBox(height: 10),

              // 3. Direct Search
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Caută magazin după nume (ex: Ikea)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _onSearch(_searchController.text),
                  ),
                ),
                onSubmitted: _onSearch,
              ),

              const SizedBox(height: 20),

              // 4. Store List
              const Text(
                'Selectează locația:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: _availableStores.isEmpty
                    ? Center(
                        child: Text(
                          _selectedCategory == null && _searchController.text.isEmpty
                              ? 'Alege o categorie sau caută un magazin.'
                              : 'Nu s-au găsit magazine în apropiere.',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _availableStores.length,
                        itemBuilder: (context, index) {
                          final store = _availableStores[index];
                          final isSelected = _selectedStore == store;
                          return Card(
                            color: isSelected ? Colors.blue.shade50 : null,
                            shape: isSelected
                                ? RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue.shade700, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  )
                                : null,
                            child: ListTile(
                              leading: const Icon(Icons.store),
                              title: Text(store.name),
                              subtitle: Text('${store.address} • ${store.distanceKm} km'),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle, color: Colors.blue.shade700)
                                  : const Icon(Icons.circle_outlined),
                              onTap: () {
                                setState(() {
                                  _selectedStore = store;
                                });
                              },
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveReminder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Salvează Notificarea', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
