import 'dart:math';
import 'package:flutter/material.dart';

class TicketQrWidget extends StatelessWidget {
  final String payload;
  final double size;

  const TicketQrWidget({
    super.key,
    required this.payload,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD0D7DE), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size - 20, size - 20),
            painter: _QrMatrixPainter(payload: payload),
          ),
          // Center CRIS/IR Emblem
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0F3260), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: const Icon(
              Icons.train,
              size: 20,
              color: Color(0xFF0F3260),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrMatrixPainter extends CustomPainter {
  final String payload;

  _QrMatrixPainter({required this.payload});

  @override
  void paint(Canvas canvas, Size size) {
    final paintDark = Paint()..color = const Color(0xFF111827);
    final matrixSize = 25; // 25x25 QR grid
    final cellSize = size.width / matrixSize;

    // Deterministic pseudo-random pattern based on payload characters
    final seed = payload.hashCode.abs();
    final rng = Random(seed);

    for (int r = 0; r < matrixSize; r++) {
      for (int c = 0; c < matrixSize; c++) {
        // Corner Finder Patterns (7x7 in top-left, top-right, bottom-left)
        final isTopLeft = (r < 7 && c < 7);
        final isTopRight = (r < 7 && c >= matrixSize - 7);
        final isBottomLeft = (r >= matrixSize - 7 && c < 7);

        // Center cutout for CRIS logo
        final isCenter = (r >= 10 && r <= 14 && c >= 10 && c <= 14);

        if (isCenter) continue;

        if (isTopLeft || isTopRight || isBottomLeft) {
          final lr = isTopLeft ? r : (isTopRight ? r : r - (matrixSize - 7));
          final lc = isTopLeft ? c : (isTopRight ? c - (matrixSize - 7) : c);

          if (lr == 0 || lr == 6 || lc == 0 || lc == 6 || (lr >= 2 && lr <= 4 && lc >= 2 && lc <= 4)) {
            canvas.drawRect(
              Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize),
              paintDark,
            );
          }
        } else {
          // Timing lines or data cells
          if (r == 6 || c == 6) {
            if ((r + c) % 2 == 0) {
              canvas.drawRect(
                Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize),
                paintDark,
              );
            }
          } else {
            // Pseudo-random data module
            if (rng.nextDouble() > 0.45) {
              canvas.drawRect(
                Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize),
                paintDark,
              );
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrMatrixPainter oldDelegate) =>
      oldDelegate.payload != payload;
}
