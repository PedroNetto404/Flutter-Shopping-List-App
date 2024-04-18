import 'dart:collection';

import 'package:mobile_shopping_list_app/extensions/extensions.dart';

import './enums/unit-type.dart';
import 'shopping-item.dart';

class ShoppingList {
  String _id = '';
  final String _userId;
  String _name;
  final DateTime _createdAt;

  final List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => List<ShoppingItem>.from(_items);

  String get id => _id;

  DateTime get createdAt => _createdAt;

  bool get isEmpty => _items.isEmpty;

  double? get totalPrice {
    if (_items.isEmpty || _items.any((element) => element.price == null)) {
      return null;
    }

    return _items.fold(
        0.0, (previousValue, item) => previousValue! + (item.totalPrice!));
  }

  set id(String value) {
    if (_id.isNotEmpty) {
      throw Exception('Id can only be set once');
    }

    if (value.isEmpty) {
      throw Exception('Id cannot be empty');
    }

    _id = value;
  }

  String get userId => _userId;

  String get name => _name;

  set name(String value) {
    if (value.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    _name = value;
  }

  ShoppingList.create({
    required String userId,
    required String name,
  })  : _userId = userId,
        _name = name.capitalize(),
        _createdAt = DateTime.now();

  ShoppingList.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _userId = json['user_id'],
        _name = json['name'],
        _createdAt = json['created_at'].toDate() {
    _items.addAll((json['items'] as List).map((e) => ShoppingItem.fromJson(e)));
  }

  bool get completed => !isEmpty && _items.every((element) => element.purchased);

  void addItem(
      {required String name,
      required String category,
      required double quantity,
      required UnitType unityType,
      String note = ''}) {
    var existingItem = _items
        .where((element) => element.name.toLowerCase() == name.toLowerCase())
        .firstOrNull;

    if (existingItem != null) {
      existingItem.quantity += quantity;
      return;
    }

    var item = ShoppingItem.create(
      listId: _id,
      name: name,
      category: category,
      quantity: quantity,
      unityType: unityType,
      note: note,
    );

    _items.add(item);
  }

  void removeItem(ShoppingItem item) => _items.remove(item);

  toJson() => {
        'user_id': userId,
        'name': name,
        'created_at': createdAt,
        'items': _items.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => '*Lista de compras:* $name\n\n'
      '\t*Criada em:* ${_createdAt.toLocal()}\n'
      '\t*Itens:* ${_items.length}\n'
      '\t*Total:* ${totalPrice == null ? '...' : totalPrice!.toCurrency()}\n'
      '\t*Concluída:* ${completed ? 'Sim' : 'Não'}\n\n'
      '\n\n*Itens:*\n\n'
      '${_items.map(_mapItemToString).join('\n')}';

  String _mapItemToString(ShoppingItem item) => '\t\t${_items.indexOf(item) + 1}. $item';
}
