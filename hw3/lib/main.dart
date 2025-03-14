import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Cards';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: GridView.count(
          crossAxisCount: 4, //columns
          children: List.generate(16, (index) { //cards amount
            return Center(
              child: PlayingCardView(
                card: PlayingCard(Suit.clubs, CardValue.values[index % CardValue.values.length])
              ),
            );
          }),
        ),
      ),
    );
  }
}