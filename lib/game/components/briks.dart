import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Briks extends PositionComponent {
  Briks({required Vector2 size}) : super(size: size);

  final outerPaint = Paint()
    ..color = const Color(0xFF8B9876)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final innerPaint = Paint()
    ..color = const Color(0xFF8B9876)
    ..style = PaintingStyle.fill;

  // ignore: non_constant_identifier_names
  final _COLOR_NORMAL = Colors.black87;

  // ignore: non_constant_identifier_names
  final _COLOR_NULL = const Color(0xFF8B9876);

  // ignore: non_constant_identifier_names
  final _COLOR_HIGHLIGHT = const Color(0xFF560000);

  @override
  void onLoad() {
    super.onLoad();
    //margin
  }

  void normal() {
    outerPaint.color = _COLOR_NORMAL;
    innerPaint.color = _COLOR_NORMAL;
  }

  void nullColor() {
    outerPaint.color = _COLOR_NULL;
    innerPaint.color = _COLOR_NULL;
  }

  void highlight() {
    outerPaint.color = _COLOR_HIGHLIGHT;
    innerPaint.color = _COLOR_HIGHLIGHT;
  }

  @override
  void render(Canvas canvas) {
    final outerRect = Rect.fromLTWH(
      10, // Left padding
      10, // Top padding
      size.x, // Kích thước x
      size.y, // Kích thước y
    );

    // Vẽ ô vuông bên ngoài với đường viền
    canvas.drawRect(outerRect, outerPaint);

    // Tính toán kích thước và vị trí của ô vuông bên trong
    final innerSize = Size(
        size.x - 8, size.y - 8); // Giảm kích thước để tạo padding cả hai bên
    final innerPosition = Offset(
      (size.x - innerSize.width) / 2 +
          10, // Căn giữa theo chiều ngang và thêm padding bên ngoài
      (size.y - innerSize.height) / 2 +
          10, // Căn giữa theo chiều dọc và thêm padding bên ngoài
    );

    // Vẽ ô vuông bên trong với màu và không rỗng
    canvas.drawRect(
        Rect.fromLTWH(innerPosition.dx, innerPosition.dy, innerSize.width,
            innerSize.height),
        innerPaint);
  }
}
