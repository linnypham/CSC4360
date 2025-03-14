import 'dart:math';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Card Pairs';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: CardGrid(),
      ),
    );
  }
}

class CardGrid extends StatefulWidget {
  @override
  _CardGridState createState() => _CardGridState();
}

class _CardGridState extends State<CardGrid> {
  late List<PlayingCard> cards;

  @override
  void initState() {
    super.initState();
    cards = _generateCardPairs();
  }

  List<PlayingCard> _generateCardPairs() {
    final random = Random();
    List<PlayingCard> uniqueCards = [];

    while (uniqueCards.length < 8) {
      var suit = Suit.values[random.nextInt(Suit.values.length)];
      var value = CardValue.values[random.nextInt(CardValue.values.length)];
      var newCard = PlayingCard(suit, value);

      if (!uniqueCards.contains(newCard)) {
        uniqueCards.add(newCard);
      }
    }

    List<PlayingCard> pairedCards = [...uniqueCards, ...uniqueCards];

    pairedCards.shuffle();

    return pairedCards;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 4, 
        children: List.generate(cards.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: PlayingCardView(
              card: cards[index],
              showBack: true),
          );
        }),
      ),
    );
  }
}
