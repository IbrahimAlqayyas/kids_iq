import 'package:flutter/material.dart';

void showGameCompletionDialog(
  BuildContext context, {
  required VoidCallback onPlayAgain,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '🎉 Great Job! 🎉',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PressStart',
            fontSize: 16,
            color: Colors.pink,
          ),
        ),
      ),
      content: const Text(
        'You completed\nall games!\n\nSuper Smart! 🌟',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'PressStart',
          fontSize: 12,
          height: 1.6,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            onPlayAgain();
          },
          icon: const Icon(Icons.refresh_outlined, color: Colors.white),
          label: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Play Again',
              style: TextStyle(
                fontFamily: 'PressStart',
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
