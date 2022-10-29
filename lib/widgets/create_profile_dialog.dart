import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/user.dart';
import 'update_user_profile.dart';

Widget createProfileDialog({
  BuildContext context,
  MUser currentUser,
  List<Book> bookList,
}) {
  final TextEditingController displayNameController =
      TextEditingController(text: currentUser.displayName);
  final TextEditingController professionController =
      TextEditingController(text: currentUser.profession);
  final TextEditingController quoteController =
      TextEditingController(text: currentUser.quote);
  final TextEditingController avatarController =
      TextEditingController(text: currentUser.avatarUrl);

  return UpdateUserProfile(
    currentUser: currentUser,
    displayNameController: displayNameController,
    professionController: professionController,
    quoteController: quoteController,
    avatarController: avatarController,
  );
}
