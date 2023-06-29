import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/items.dart';
import 'package:riverpod_app/providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late List<Item> items = [];

  @override
  void initState() {
    super.initState();
    initialiseItems();
  }

  void initialiseItems() {
    final data = ref.read(dataProvider);
    items = data
        .map((itemData) => Item(
              title: itemData['title'],
              imagePath: itemData['image'],
              price: itemData['price'],
              id: itemData['id'],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(itemsProvider);
    final totalPrice = ref.watch(totalPriceProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        title: const Text('Cart Page'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Item item = items[index];
                    final counter = ref.watch(counterProvider(item.id));
                    return Card(
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1, child: Image.asset(item.imagePath)),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Item: ${item.title}",
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    Text("Price: ${item.price}"),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              ref
                                                  .read(counterProvider(item.id)
                                                      .notifier)
                                                  .decrement();
                                            },
                                            icon: const Icon(Icons.remove)),
                                        Text(
                                          counter.toString(),
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              ref
                                                  .read(counterProvider(item.id)
                                                      .notifier)
                                                  .increment();
                                            },
                                            icon: const Icon(Icons.add))
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.grey),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total: $totalPrice',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
