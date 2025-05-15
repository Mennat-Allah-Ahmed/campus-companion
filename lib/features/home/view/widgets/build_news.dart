import 'package:flutter/material.dart';

class BuildNews extends StatelessWidget {
  final String imagePath;
  final String description;
  final String date;

  const BuildNews({
    super.key,
    required this.imagePath,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width * 0.22,
          height: size.width * 0.22,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                date,
                style: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
