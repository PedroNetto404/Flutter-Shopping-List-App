import 'package:flutter/material.dart';

import '../services/services.dart';
import '../models/models.dart';

class ShoppingListProvider extends ChangeNotifier {
  final _shoppingListRepository = ShoppingListRepository();
  final _auth = AuthService();

  final List<ShoppingList> _lists = [];

  List<ShoppingList> get lists => _lists.toList();

  ShoppingList getList(String listId) =>
      _lists.firstWhere((element) => element.id == listId);

  Future<void> fetchLists() async {
    if (_lists.isNotEmpty) return;

    var userId = _auth.currentUser!.uid;
    final lists = await _shoppingListRepository.getAll(userId);

    _lists.clear();
    _lists.addAll(lists);
  }

  Future<void> addShoppingList(String name, String userId) async {
    final shoppingList =
        ShoppingList.create(userId: userId, name: name);

    await _shoppingListRepository.create(shoppingList);
    _lists.add(shoppingList);
    notifyListeners();
  }

  Future<void> removeShoppingList(String listId) async {
    await _shoppingListRepository.delete(listId);
    _lists.removeWhere((element) => element.id == listId);
    notifyListeners();
  }

  Future<void> addItemToShoppingList(
      {required String listId,
      required String name,
      required double quantity,
      required UnitType unityType,
      required String category,
      required String note}) async {
    final shoppingList = _lists.firstWhere((element) => element.id == listId);
    shoppingList.addItem(
        name: name,
        category: category,
        quantity: quantity,
        unityType: unityType,
        note: note);

    await _shoppingListRepository.update(shoppingList);

    notifyListeners();
  }

  Future<void> removeItemFromShoppingList(ShoppingItem item) async {
    final shoppingList =
        _lists.firstWhere((element) => element.id == item.listId);
    shoppingList.removeItem(item);

    await _shoppingListRepository.update(shoppingList);

    notifyListeners();
  }

  Future<void> updateShoppingListName(String listId, String name) async {
    final shoppingList = _lists.firstWhere((element) => element.id == listId);
    shoppingList.name = name;

    await _shoppingListRepository.update(shoppingList);

    notifyListeners();
  }

  Future<void> updateShoppingItem(
      {required String listId,
      required String previousItemName,
      required String newName,
      required double newQuantity,
      required UnitType newUnitType,
      required String newCategory,
      String? newNote,
      double? newPrice}) async {
    final shoppingList = _lists.firstWhere((element) => element.id == listId);
    final item = shoppingList.items
        .firstWhere((element) => element.name == previousItemName);

    item.name = newName;
    item.quantity = newQuantity;
    item.unityType = newUnitType;
    item.category = newCategory;
    item.note = newNote;
    if (newPrice != null) item.price = newPrice;

    await _shoppingListRepository.update(shoppingList);

    notifyListeners();
  }

  Future<void> buyItem(
      ShoppingItem item, double newQuantity, double price) async {
    final shoppingList =
        _lists.firstWhere((element) => element.id == item.listId);

    item.purchase(newQuantity, price);

    return _shoppingListRepository.update(shoppingList);
  }
}
