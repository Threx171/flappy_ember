import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Trees extends SpriteComponent {
  Trees() : super(priority: -1);

  @override
  Future<void>? onLoad() async {
    final image = await Flame.images.load('./parallax/fbg_trees_01.png');

    sprite = Sprite(image);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    this.size = size;
  }
}
