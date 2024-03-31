import 'shopping-item.dart';

class ShoppingList {
  final DateTime _createdAt;
  String _name;
  final List<ShoppingItem> _items = [];

  ShoppingList(String name, {List<ShoppingItem> items = const []})
      : _name = name,
        _createdAt = DateTime.now() {
    if (name.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    _items.addAll(items);
  }

  String get name => _name;

  set name(String name) {
    if (name.isNotEmpty) {
      _name = name;
    }

    throw Exception('Name cannot be empty');
  }

  DateTime get createdAt => _createdAt;

  List<ShoppingItem> get items => List.unmodifiable(_items);

  void addItem(ShoppingItem item) {
    ShoppingItem? existingItem = _items.firstWhere(
        (element) => element.name.toLowerCase() == item.name.toLowerCase(),
        orElse: () => null!);

    if (existingItem != null) {
      existingItem.quantity += item.quantity;
    } else {
      _items.add(item);
    }
  }

  void removeItem(ShoppingItem item) {
    _items.remove(item);
  }
}
