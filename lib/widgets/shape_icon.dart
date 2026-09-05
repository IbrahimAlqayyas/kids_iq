import 'package:flutter/material.dart';

class ShapeIcon extends StatelessWidget {
  final String shape;
  final bool isOutlined;
  final double size;
  final Color? color;

  const ShapeIcon({
    super.key,
    required this.shape,
    this.isOutlined = false,
    required this.size,
    this.color,
  });

  static Color defaultColor(String shape) {
    switch (shape) {
      case 'circle':
        return Colors.redAccent;
      case 'square':
        return Colors.green;
      case 'triangle':
        return Colors.deepOrangeAccent;
      case 'star':
        return Colors.amber.shade700;
      case 'diamond':
        return Colors.teal;
      case 'heart':
        return Colors.purpleAccent;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? defaultColor(shape);
    switch (shape) {
      case 'circle':
        return Icon(
          isOutlined ? Icons.circle_outlined : Icons.circle,
          color: iconColor,
          size: size,
        );
      case 'square':
        return Icon(
          isOutlined ? Icons.square_outlined : Icons.square,
          color: iconColor,
          size: size,
        );
      case 'triangle':
        return isOutlined
            ? Icon(
                Icons.change_history_rounded,
                color: iconColor,
                size: size,
              )
            : RotatedBox(
                quarterTurns: 3,
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: iconColor,
                  size: size * 1.15,
                ),
              );
      case 'star':
        return Icon(
          isOutlined ? Icons.star_outline_rounded : Icons.star_rounded,
          color: iconColor,
          size: size,
        );
      case 'diamond':
        return Icon(
          isOutlined ? Icons.diamond_outlined : Icons.diamond_rounded,
          color: iconColor,
          size: size,
        );
      case 'heart':
        return Icon(
          isOutlined ? Icons.favorite_border_rounded : Icons.favorite_rounded,
          color: iconColor,
          size: size,
        );
      default:
        return Icon(Icons.star, color: iconColor, size: size);
    }
  }
}
