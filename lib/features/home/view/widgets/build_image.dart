import 'package:flutter/material.dart';

class BuildImageCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final double width;
  final double height;

  const BuildImageCard({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            imagePath,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.5),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
