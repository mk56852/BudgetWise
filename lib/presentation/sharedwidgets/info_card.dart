import 'package:budget_wise/core/constants/Colors.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String body;
  final Color graphColor;
  final bool isPositive;

  const InfoCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.body,
      required this.graphColor,
      required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subTitle,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: isPositive ? Colors.greenAccent : Colors.redAccent,
            size: 14,
          ),
          const Spacer(),
          CustomPaint(
            size: const Size(140, 50),
            painter: CryptoGraphPainter(graphColor: graphColor),
          ),
        ],
      ),
    );
  }
}

class CryptoGraphPainter extends CustomPainter {
  final Color graphColor;

  CryptoGraphPainter({required this.graphColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = graphColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Paint fillPaint = Paint()
      ..color = graphColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    Path path = Path();
    Path fillPath = Path();

    List<Offset> points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.7),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.6),
      Offset(size.width, size.height * 0.4),
    ];

    path.moveTo(points.first.dx, points.first.dy);
    fillPath.moveTo(points.first.dx, points.first.dy);

    for (var point in points) {
      path.lineTo(point.dx, point.dy);
      fillPath.lineTo(point.dx, point.dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(CryptoGraphPainter oldDelegate) => false;
}
