import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants/constants.dart';
import '../models/book.dart';
import '../utils/format_date.dart';
import '../widgets/input_decoration.dart';
import '../widgets/two_sided_rounded_button.dart';

class BookDetailsDialog extends StatefulWidget {
  final Book book;

  const BookDetailsDialog({
    Key key,
    @required this.book,
  }) : super(key: key);

  @override
  State<BookDetailsDialog> createState() => _BookDetailsDialogState();
}

class _BookDetailsDialogState extends State<BookDetailsDialog> {
  TextEditingController notesController;
  bool isReadingClicked = false;
  bool isFinishedReadingClicked = false;
  double rating;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.book.id);
    rating = double.parse(widget.book.rating);
    notesController = TextEditingController(text: widget.book.notes);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleTextController =
        TextEditingController(text: widget.book.title);
    final TextEditingController authorNameController =
        TextEditingController(text: widget.book.author);
    final TextEditingController photoController =
        TextEditingController(text: widget.book.photoUrl);

    return AlertDialog(
      title: Stack(
        children: [
          /// book image
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.book.photoUrl),
                    radius: 50.0,
                  ),
                ],
              ),
              Text(widget.book.author),
            ],
          ),

          /// close icon
          Positioned(
            top: 10.0,
            right: 10.0,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
            ),
          ),
        ],
      ),
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// book title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: titleTextController,
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Book title',
                    hintText: 'Flutter Development',
                  ),
                ),
              ),

              /// author
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: authorNameController,
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Book author',
                    hintText: 'Jeff A.',
                  ),
                ),
              ),

              /// cover
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: photoController,
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Book cover',
                    hintText: '',
                  ),
                ),
              ),
              const SizedBox(height: 5.0),

              /// start reading
              TextButton.icon(
                // if start timestamp null, change isReadingClicked valuee else disable button
                onPressed: widget.book.startedReading == null
                    ? () {
                        setState(() {
                          isReadingClicked = !isReadingClicked;
                        });
                      }
                    : null,
                icon: const Icon(Icons.book_sharp),
                label: widget.book.startedReading == null
                    ? isReadingClicked
                        ? Text(
                            'Started Reading...',
                            style: TextStyle(color: Colors.blueGrey.shade300),
                          )
                        : const Text('Start Reading')
                    : Text(
                        'Started on ${formatDate(timestamp: widget.book.startedReading)}',
                      ),
              ),
              const SizedBox(height: 5.0),

              /// mark as read
              TextButton.icon(
                onPressed: widget.book.finishedReading == null
                    ? () {
                        setState(() {
                          isFinishedReadingClicked = !isFinishedReadingClicked;
                        });
                      }
                    : null,
                icon: const Icon(Icons.done_rounded),
                label: widget.book.finishedReading == null
                    ? !isFinishedReadingClicked
                        ? const Text('Mark as Read')
                        : const Text('Finished Reading')
                    : Text(
                        'Finished on${formatDate(timestamp: widget.book.finishedReading)}'),
              ),

              /// rating
              RatingBar.builder(
                itemCount: 5,
                initialRating: rating,
                allowHalfRating: true,
                itemBuilder: (BuildContext context, int index) {
                  switch (index) {
                    case 0:
                      return const Icon(
                        Icons.sentiment_very_dissatisfied_rounded,
                        color: Colors.red,
                      );
                    case 1:
                      return const Icon(
                        Icons.sentiment_dissatisfied_rounded,
                        color: Colors.redAccent,
                      );
                    case 2:
                      return const Icon(
                        Icons.sentiment_neutral_rounded,
                        color: Colors.amber,
                      );
                    case 3:
                      return const Icon(
                        Icons.sentiment_satisfied_rounded,
                        color: Colors.lightGreen,
                      );
                    case 4:
                      return const Icon(
                        Icons.sentiment_very_satisfied_rounded,
                        color: Colors.green,
                      );
                    default:
                      return Container();
                  }
                },
                onRatingUpdate: (double ratingStar) {
                  print(ratingStar);
                  setState(() {
                    rating = ratingStar;
                  });
                },
              ),

              /// notes
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: notesController,
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Your thoughts',
                    hintText: 'Enter notes',
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// update
                  TwoSidedRoundedButton(
                    text: 'Update',
                    radius: 12.0,
                    color: kIconColor,
                    press: () {
                      /// update iff new data was entered
                      final bool userChangedTitle =
                          widget.book.title != titleTextController.text;
                      final bool userChangedAuthor =
                          widget.book.author != authorNameController.text;
                      final bool userChangedPhotoUrl =
                          widget.book.author != photoController.text;
                      final bool userChangedRating =
                          double.parse(widget.book.rating) != rating;
                      final bool userChangedNotes =
                          widget.book.notes != notesController.text;

                      final bool updateBook = userChangedTitle ||
                          userChangedAuthor ||
                          userChangedPhotoUrl ||
                          userChangedRating ||
                          userChangedNotes;
                      if (updateBook) {
                        Book bookToBeUpdated = Book(
                          userId: FirebaseAuth.instance.currentUser.uid,
                          title: titleTextController.text,
                          author: authorNameController.text,
                          photoUrl: photoController.text,
                          startedReading: isReadingClicked
                              ? Timestamp.now()
                              : widget.book.startedReading,
                          finishedReading: isFinishedReadingClicked
                              ? Timestamp.now()
                              : widget.book.finishedReading,
                          notes: notesController.text,
                          rating: rating.toString(),
                          categories: widget.book.categories,
                          pageCount: widget.book.pageCount,
                          description: widget.book.description,
                          publishedDate: widget.book.publishedDate,
                        );
                        print(bookToBeUpdated);
                        FirebaseFirestore.instance
                            .collection('books')
                            .doc(widget.book.id)
                            .update(
                              bookToBeUpdated.toMap(),
                            )
                            .then((value) {
                          Navigator.pop(context);
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),

                  /// delete
                  TwoSidedRoundedButton(
                    text: 'Delete',
                    radius: 12.0,
                    color: Colors.redAccent,
                    press: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text(
                                'Once the book is deleted you can\'t retrieve it back'),
                            actions: [
                              /// delete
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('books')
                                      .doc(widget.book.id)
                                      .delete()
                                      .then((value) {
                                    Navigator.pop(context); // delete dialog
                                    Navigator.pop(
                                        context); // book details dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Deleted successfully'),
                                      ),
                                    );
                                  });
                                },
                                child: const Text('Delete'),
                              ),

                              /// cancel
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
