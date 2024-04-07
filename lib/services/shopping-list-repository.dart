import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_shopping_list_app/models/shopping-item.dart';
import 'package:mobile_shopping_list_app/models/shopping-list.dart';

class ShoppingListRepository {
  final _shoppingListCollection =
      FirebaseFirestore.instance.collection('shopping_lists');

  Future<ShoppingList> getById(String listId) async => ShoppingList.fromJson(
      (await _shoppingListCollection.doc(listId).get()).data()!);

  Future<List<ShoppingList>> getAll(String userId) async =>
      (await _shoppingListCollection
              .where('user_id', isEqualTo: userId)
              .get()
              .then((value) => value.docs))
          .map((e) => e.data()..['id'] = e.id)
          .map(ShoppingList.fromJson)
          .toList();

  Future<void> create(ShoppingList list) async {
    var doc = await _shoppingListCollection.add(list.toJson());
    list.id = doc.id;
  }

  Future<void> update(ShoppingList list) async =>
      await _shoppingListCollection.doc(list.id).update(list.toJson());

  Future<void> delete(String listId) async =>
      await _shoppingListCollection.doc(listId).delete();
}
