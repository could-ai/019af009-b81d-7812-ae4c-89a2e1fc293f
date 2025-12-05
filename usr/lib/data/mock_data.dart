import '../models/reminder.dart';

class MockData {
  static List<Store> getStoresByCategory(String category) {
    // Simulating API response based on category
    switch (category) {
      case 'Magazin de bricolaj':
        return [
          Store(name: 'Dedeman', distanceKm: 1.2, address: 'Strada Constructorilor 5'),
          Store(name: 'Leroy Merlin', distanceKm: 3.5, address: 'Bulevardul Industriei 10'),
          Store(name: 'Hornbach', distanceKm: 8.1, address: 'Șoseaua Vestului 22'),
        ];
      case 'Magazin de mobila':
        return [
          Store(name: 'IKEA', distanceKm: 4.0, address: 'Zona Comercială Băneasa'),
          Store(name: 'JYSK', distanceKm: 0.8, address: 'Centrul Civic'),
          Store(name: 'Mobexpert', distanceKm: 5.2, address: 'Strada Fabricii'),
        ];
      case 'Farmacie':
        return [
          Store(name: 'Farmacia Tei', distanceKm: 0.2, address: 'Colț cu strada principală'),
          Store(name: 'Dr. Max', distanceKm: 0.5, address: 'Lângă piață'),
          Store(name: 'Catena', distanceKm: 1.1, address: 'Bulevardul Unirii'),
        ];
      case 'Magazin de alimente':
        return [
          Store(name: 'Lidl', distanceKm: 0.3, address: 'Strada Florilor'),
          Store(name: 'Kaufland', distanceKm: 1.5, address: 'Strada Gării'),
          Store(name: 'Mega Image', distanceKm: 0.1, address: 'La parterul blocului'),
          Store(name: 'Carrefour', distanceKm: 2.8, address: 'Mall Shopping City'),
        ];
      default:
        return [];
    }
  }

  static List<Store> searchStores(String query) {
    return [
      Store(name: '$query (Locație Centru)', distanceKm: 2.1, address: 'Centru'),
      Store(name: '$query (Locație Nord)', distanceKm: 7.5, address: 'Zona Nord'),
      Store(name: '$query (Locație Sud)', distanceKm: 9.8, address: 'Zona Sud'),
    ];
  }
}
