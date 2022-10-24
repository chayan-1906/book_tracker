import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate({@required Timestamp timestamp}) {
  return DateFormat('MMM dd, yyyy').format(timestamp.toDate());
}
