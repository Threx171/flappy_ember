import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flappy_ember/player.dart';
import 'utils_websockets.dart';

import 'ground.dart';
import 'sky.dart';
import 'trees.dart';
import 'fog.dart';
import 'boxstack.dart';

class FlappyEmber extends FlameGame with TapDetector, HasCollisionDetection {
  late final Player player;
  double speed = 500;
  final random = Random();
  TextComponent? scoreText;
  late WebSocketsHandler websocket;
  int score = 0;
  @override
  Future<void>? onLoad() async {
    player = Player();
    add(Sky());
    add(Ground());
    add(Fog());
    add(ScreenHitbox());
    add(player);
    scoreText = TextComponent(text: 'Score: $score');
    scoreText!.anchor = Anchor.topLeft;
    scoreText!.x = 10.0;
    scoreText!.y = 10.0;
    add(scoreText!);
    return null;
  }

  void gameover() {
    pauseEngine();
  }

  double _timeSinceBox = 0;
  double _boxInterval = 0.9;
  @override
  void update(double dt) {
    super.update(dt);
    speed += 10 * dt;
    _timeSinceBox += dt;

    if (_timeSinceBox > _boxInterval) {
      add(BoxStack(isBottom: random.nextBool()));
      _timeSinceBox = 0;
    }
    scoreText?.text = 'Puntuación: $score';
  }

  void initializeGame({required bool loadHud}) {
    // Initialize websocket
    initializeWebSocket();
  }

  void initializeWebSocket() {
    websocket = WebSocketsHandler();
    websocket.connectToServer("localhost", 8888, serverMessageHandler);
  }

  void serverMessageHandler(String message) {
    print("Message received: $message");
    // Processar els missatges rebuts
    final data = json.decode(message);

    // Comprovar si 'data' és un Map i si 'type' és igual a 'data'
    if (data is Map<String, dynamic>) {
      if (data['type'] == 'welcome') {
        initPlayer(data['id'].toString());
      }
      if (data['type'] == 'data') {
        var value = data['value'];
        if (value is List) {
          //updateOpponents(value);
        }
      }
    }
  }

  void initPlayer(String id) {
    final List<String> randomNames = [
      "Alice",
      "Bob",
      "Charlie",
      "David",
      "Eva",
      "Frank",
      "Grace",
      "Hank",
      "Ivy",
      "Jack"
    ];
    final random = Random();
    final randomName = randomNames[random.nextInt(randomNames.length)];

    websocket.sendMessage('{"type": "init", "name": "$randomName", "}');
  }

  @override
  void onTap() {
    super.onTap();
    player.fly();
  }
}
