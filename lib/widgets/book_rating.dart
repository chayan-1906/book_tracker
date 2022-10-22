import 'package:book_tracker/constants/constants.dart';
import 'package:flutter/material.dart';

class BookRating extends StatelessWidget {
  final double score;

  const BookRating({Key key, this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(3, 7),
            blurRadius: 20.0,
            color: const Color(0xFFD3D3D3).withOpacity(0.5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.star_rounded, color: kIconColor, size: 15.0),
          const SizedBox(height: 15.0),
          Text(
            '$score',
            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
