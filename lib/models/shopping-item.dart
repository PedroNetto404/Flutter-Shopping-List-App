import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/models/enums/unit-type.dart';

class ShoppingItem {
  String name;
  UnityType unityType;
  double quantity;
  bool buyed;
  String category;

  ShoppingItem(this.name, this.unityType, this.quantity, this.category, {this.buyed = false});
}
