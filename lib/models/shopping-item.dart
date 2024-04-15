import '../models/enums/unit-type.dart';

class ShoppingItem {
  String _name;
  UnitType unityType;
  double _quantity;
  bool _purchased;
  String _category;
  String? note;

  String get name => _name;

  set name(String value) {
    if (value.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    _name = value;
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

  void purchase() => _purchased = true;

  String get category => _category;

  set category(String value) {
    if (value.isEmpty) {
      throw Exception('Category cannot be empty');
    }

    _category = value;
  }

  ShoppingItem.create({
    required String name,
    required this.unityType,
    required double quantity,
    required String category,
    this.note,
  })  : _name = name,
        _quantity = quantity,
        _purchased = false,
        _category = category;

  ShoppingItem.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        unityType = UnitType.values.firstWhere((element) =>
            element.toString().split('.').last == json['unity_type']),
        _quantity = double.parse(json['quantity'].toString()),
        _purchased = json['purchased'],
        _category = json['category'],
        note = json['note'];

  Map<String, Object?> toJson() => {
        'name': name,
        'unity_type': unityType.toString().split('.').last,
        'quantity': quantity,
        'purchased': purchased,
        'category': _category,
        'note': note,
      };
}
