import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/models/book.dart';
import 'package:flutter/material.dart';

import 'book_rating.dart';
import 'two_sided_rounded_button.dart';

class ReadingListCard extends StatelessWidget {
  final String image;
  final String title;
  final String author;
  final double rating;
  final String buttonText;
  final Book book;
  final bool isRead;
  final Function pressRead;

  const ReadingListCard({
    Key key,
    this.image,
    this.title,
    this.author,
    this.rating = 4.4,
    this.buttonText,
    this.book,
    this.isRead,
    this.pressRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 202.0,
      margin: const EdgeInsets.only(left: 24.0, bottom: 0.0),
      child: Stack(
        children: [
          Positioned(
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 244.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 33.0,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Image.network(image, width: 100.0),
          ),
          Positioned(
            top: 23.0,
            right: 10.0,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_rounded),
                ),
                BookRating(score: rating),
              ],
            ),
          ),
          Positioned(
            top: 160.0,
            child: Container(
              height: 85.0,
              width: 202.0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        style: const TextStyle(color: kBlackColor),
                        children: [
                          TextSpan(
                            text: '$title\n',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: author,
                            style: const TextStyle(color: kLightBlackColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        width: 100.0,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        alignment: Alignment.center,
                        child: const Text('Details'),
                      ),
                      Expanded(
                        child: TwoSidedRoundedButton(
                          text: buttonText,
                          press: pressRead,
                          radius: 30.0,
                          color: kLightPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
