import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const SnakeGame());

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      
      darkTheme: ThemeData.light(),
      home: const SnakeGamePage(),
      
    );
  }
}

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({super.key});

  @override
  _SnakeGamePageState createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  static const int numRows = 20;
  static const int numCols = 20;
  static const double cellSize = 20.0;

  List<int> snake = [45, 44]; // initial positions of the snake (head and body)
  int food = 0; // initial position of the food

  Direction direction = Direction.right;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    const duration = Duration(milliseconds: 300);

    snake = [45, 44];
    food = Random().nextInt(numRows * numCols);

    setState(() {
      isPlaying = true;
    });

    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (!isPlaying) {
        timer.cancel();
        gameOver();
      }
    });
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case Direction.up:
          if (snake.first < numCols) {
            isPlaying = false;
            return;
          }
          snake.insert(0, snake.first - numCols);
          break;
        case Direction.down:
          if (snake.first >= (numRows - 1) * numCols) {
            isPlaying = false;
            return;
          }
          snake.insert(0, snake.first + numCols);
          break;
        case Direction.left:
          if (snake.first % numCols == 0) {
            isPlaying = false;
            return;
          }
          snake.insert(0, snake.first - 1);
          break;
        case Direction.right:
          if ((snake.first + 1) % numCols == 0) {
            isPlaying = false;
            return;
          }
          snake.insert(0, snake.first + 1);
          break;
      }

      if (snake.first == food) {
        food = Random().nextInt(numRows * numCols);
      } else {
        snake.removeLast();
      }
    });
  }

  void gameOver() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('Would you like to play again?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              startGame();
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isPlaying = false;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        
      ),
      body: SingleChildScrollView(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (direction != Direction.up && details.delta.dy > 0) {
                    direction = Direction.down;
                  } else if (direction != Direction.down && details.delta.dy < 0) {
                    direction = Direction.up;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != Direction.left && details.delta.dx > 0) {
                    direction = Direction.right;
                  } else if (direction != Direction.right && details.delta.dx < 0) {
                    direction = Direction.left;
                  }
                },
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numCols,
                  ),
                  itemCount: numRows * numCols,
                  itemBuilder: (BuildContext context, int index) {
                    final isSnake = snake.contains(index);
                    final isFood = food == index;

                    return Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isSnake
                            ? Colors.blue
                            : isFood
                                ? Colors.red
                                : Colors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  
  }
}

enum Direction { up, down, left, right }
