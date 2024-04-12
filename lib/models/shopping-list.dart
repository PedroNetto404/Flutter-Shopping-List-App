import 'dart:collection';

import 'package:mobile_shopping_list_app/models/enums/unit-type.dart';

import 'shopping-item.dart';

class ShoppingList {
  String _id = '';
  final String _userId;
  String _name;
  final DateTime _createdAt;

  final List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => List<ShoppingItem>.from(_items);

  String get id => _id;

  get createdAt => _createdAt;

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
        _name = name,
        _createdAt = DateTime.now();

  ShoppingList.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _userId = json['user_id'],
        _name = json['name'],
        _createdAt = json['created_at'].toDate() {
    _items.addAll((json['items'] as List).map((e) => ShoppingItem.fromJson(e)));
  }

  bool get completed => items.every((element) => element.purchased);

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
      name: name,
      category: category,
      quantity: quantity,
      unityType: unityType,
      note: note,
    );

    _items.add(item);
  }

  void removeItem(int itemId) => _items.removeWhere((element) => element.id == itemId);

  void complete() {
    for (var element in _items) {
      element.purchase();
    }
  }

  void reset() {
    for (var element in _items) {
      element.unPurchase();
    }
  }

  toJson() => {
        'user_id': userId,
        'name': name,
        'created_at': createdAt,
        'items': _items.map((e) => e.toJson()).toList(),
      };
}
