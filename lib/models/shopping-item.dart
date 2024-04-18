import 'package:mobile_shopping_list_app/extensions/extensions.dart';

import '../models/enums/unit-type.dart';

class ShoppingItem {
  final String _listId;
  double? _price;
  String _name;
  UnitType unityType;
  double _quantity;
  bool _purchased;
  String _category;
  String? note;

  String get listId => _listId;

  String get name => _name;

  double? get price => _price;

  set price(double? value) {
    if (value != null && value <= 0) {
      throw Exception('Price must be greater than 0');
    }

    _price = value;
  }

  double? get totalPrice => _price != null ? _price! * _quantity : null;

  set name(String value) {
    if (value.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    _name = value.capitalize();
  }

  double get quantity => _quantity;

  set quantity(double value) {
    if (value <= 0) {
      throw Exception('Quantity must be greater than 0');
    }

    _quantity = value;
  }

  bool get purchased => _purchased;

  void unPurchase() => _purchased = false;

  void purchase(double price, double quantity) {
    _purchased = true;
    _quantity = quantity;
    _price = price;
  }

  String get category => _category;

  set category(String value) {
    if (value.isEmpty) return;
    _category = value.capitalize();
  }

  ShoppingItem.create({
    required String listId,
    required String name,
    required this.unityType,
    required double quantity,
    required String category,
    this.note,
  })  : _listId = listId,
        _name = name.capitalize(),
        _quantity = quantity,
        _purchased = false,
        _category = category.capitalize();

  ShoppingItem.fromJson(Map<String, dynamic> json)
      : _listId = json['list_id'],
        _name = json['name'],
        _price = json['price'],
        unityType = UnitType.values.firstWhere((element) =>
            element.toString().split('.').last == json['unity_type']),
        _quantity = double.parse(json['quantity'].toString()),
        _purchased = json['purchased'],
        _category = json['category'],
        note = json['note'];

  Map<String, Object?> toJson() => {
        'list_id': _listId,
        'name': name,
        'price': _price,
        'unity_type': unityType.toString().split('.').last,
        'quantity': quantity,
        'purchased': purchased,
        'category': _category,
        'note': note,
      };

  @override
  String toString() {
    final name = _name.length > 20 ? _name.substring(0, 20) : _name;
    final note = this.note != null && this.note!.isNotEmpty
        ? this.note!.length > 30
            ? this.note?.substring(0, 30)
            : this.note
        : '';
    final unitType = unityType.toString().split('.').last;

    return '\t [ ${_purchased ? 'x' : '\t'} ]  $name  $_quantity $unitType} ${_price?.toCurrency() ?? '...'} $note';
  }
}
