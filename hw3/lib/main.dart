import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CardMatchingGame(),
      ),
    );
  }
}

class CardModel {
  final String id;
  final String image;
  bool isFaceUp;
  bool isMatched;

  CardModel({required this.id, required this.image, this.isFaceUp = false, this.isMatched = false});
}

class GameProvider extends ChangeNotifier {
  List<CardModel> cards = [];
  CardModel? firstSelected;
  bool isChecking = false;

  GameProvider() {
    _initializeGame();
  }

  void _initializeGame() {
  List<String> images = List.generate(8, (index) => 'assets/card_$index.png');
  List<String> pairedImages = [...images, ...images]..shuffle(Random());

  cards = List.generate(pairedImages.length, (index) => 
    CardModel(id: index.toString(), image: pairedImages[index])
  );
  notifyListeners();
}


  void flipCard(CardModel card) {
  if (isChecking || card.isFaceUp || card.isMatched) return;

  card.isFaceUp = true;
  notifyListeners();

  firstSelected == null ? firstSelected = card : _checkMatch(card);
  }


  void _checkMatch(CardModel secondSelected) async {
  isChecking = true;
  await Future.delayed(const Duration(seconds: 1));

  var first = firstSelected;
  if (first != null && first.image == secondSelected.image) {
    first.isMatched = secondSelected.isMatched = true;
  } else {
    first?.isFaceUp = secondSelected.isFaceUp = false;
  }

  firstSelected = null;
  isChecking = false;
  notifyListeners();
  }

  void resetGame() {
    firstSelected = null;
    isChecking = false;
    _initializeGame();  
    notifyListeners();
  }
}
  

class CardMatchingGame extends StatelessWidget {
  const CardMatchingGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MTG Matching')),
      body: Consumer<GameProvider>(
        builder: (context, game, child) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: game.cards.length,
            itemBuilder: (context, index) {
              return CardWidget(card: game.cards[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<GameProvider>().resetGame();  
        },
        tooltip: 'Reset Game',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}


class CardWidget extends StatelessWidget {
  final CardModel card;
  const CardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<GameProvider>().flipCard(card),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return RotationYTransition(animation: animation, child: child);
        },
        child: card.isFaceUp || card.isMatched
            ? Image.asset(card.image, key: ValueKey(card.id))
            : Image.asset(
                'assets/card_back.jpeg',  
                key: ValueKey('back_${card.id}'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class RotationYTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const RotationYTransition({super.key, required this.child, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final angle = animation.value * pi;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(angle),
          child: animation.value > 0.5
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: child,
                )
              : child,
        );
      },
      child: child,
    );
  }
}
