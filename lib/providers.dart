import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/items.dart';

final counterProvider =
    StateNotifierProvider.family<Counter, int, int>((ref, id) {
  return Counter(id: id);
});

class Counter extends StateNotifier<int> {
  final int id;
  Counter({required this.id}) : super(1);

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}

final dataProvider = Provider<List<Map>>((ref) {
  List<Map> data = [
    {"title": "Laptop", "image": "assets/laptop.jpeg", "price": 2000, "id": 1},
    {
      "title": "Head Phones",
      "image": "assets/headphones.jpeg",
      "price": 3000,
      "id": 2
    },
    {"title": "Phone", "image": "assets/phone.jpeg", "price": 4500, "id": 3},
    {"title": "Phone", "image": "assets/phone.jpeg", "price": 4500, "id": 4},
  ]; // Return the data list
  return data;
});

final itemsProvider = Provider<List<Item>>((ref) {
  final data = ref.watch(dataProvider);
  return data
      .map((itemData) => Item(
            title: itemData['title'],
            imagePath: itemData['image'],
            price: itemData['price'],
            id: itemData['id'],
          ))
      .toList();
});

final totalPriceProvider = Provider<int>((ref) {
  final items = ref.watch(itemsProvider);

  int total = 0;
  for (var item in items) {
    final counter = ref.watch(counterProvider(item.id));
    total += item.price * counter;
  }
  return total;
});
