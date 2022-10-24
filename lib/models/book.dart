import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String notes;
  final String categories;
  final String description;
  final String photoUrl;
  final String publishedDate;
  final String rating;
  final String userId;
  final int pageCount;
  final Timestamp startedReading;
  final Timestamp finishedReading;

  Book({
    this.id,
    this.title,
    this.author,
    this.notes,
    this.categories,
    this.description,
    this.photoUrl,
    this.publishedDate,
    this.rating,
    this.userId,
    this.pageCount,
    this.startedReading,
    this.finishedReading,
  });

  factory Book.fromDocument(QueryDocumentSnapshot data) {
    return Book(
      id: data.id,
      title: data.get('title'),
      author: data.get('author'),
      notes: data.get('notes'),
      categories: data.get('categories'),
      description: data.get('description'),
      photoUrl: data.get('photo_url'),
      publishedDate: data.get('published_date'),
      rating: data.get('rating'),
      userId: data.get('user_id'),
      pageCount: data.get('page_count'),
      startedReading: data.get('started_reading'),
      finishedReading: data.get('finished_reading'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'user_id': userId,
      'author': author,
      'notes': notes,
      'photo_url': photoUrl,
      'published_date': publishedDate,
      'description': description,
      'page_count': pageCount,
      'categories': categories,
      'rating': rating,
      'started_reading': startedReading,
      'finished_reading': finishedReading,
    };
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, notes: $notes, categories: $categories, description: $description, photoUrl: $photoUrl, publishedDate: $publishedDate, rating: $rating, userId: $userId, pageCount: $pageCount, startedReading: $startedReading, finishedReading: $finishedReading}';
  }
}
