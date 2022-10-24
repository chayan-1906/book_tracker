import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'input_decoration.dart';

class UpdateUserProfile extends StatelessWidget {
  const UpdateUserProfile({
    Key key,
    @required this.currentUser,
    @required this.displayNameController,
    @required this.professionController,
    @required this.quoteController,
    @required this.avatarController,
  }) : super(key: key);

  final MUser currentUser;
  final TextEditingController displayNameController;
  final TextEditingController professionController;
  final TextEditingController quoteController;
  final TextEditingController avatarController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('Edit ${currentUser.displayName}'),
      ),
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// profile picture
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(currentUser.avatarUrl ??
                      'https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/female/10.png'),
                  radius: 50.0,
                ),
              ),

              /// display name textformfield
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: displayNameController,
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Your name',
                    hintText: '',
                  ),
                ),
              ),

              /// profession textformfield
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: professionController,
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Profession',
                    hintText: '',
                  ),
                ),
              ),

              /// quote textformfield
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: quoteController,
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Favorite Quote',
                    hintText: '',
                  ),
                ),
              ),

              /// avatar textformfield
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: avatarController,
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Avatar URL',
                    hintText: '',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        /// update
        TextButton(
          onPressed: () {
            final bool userChangedName =
                currentUser.displayName != displayNameController.text;
            final bool userChangedProfession =
                currentUser.profession != professionController.text;
            final bool userChangedQuote =
                currentUser.quote != quoteController.text;
            final bool userChangedAvatar =
                currentUser.avatarUrl != avatarController.text;
            final bool userNeedUpdate = userChangedName ||
                userChangedProfession ||
                userChangedQuote ||
                userChangedAvatar;
            if (userNeedUpdate) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.id)
                  .update(
                    MUser(
                      uid: currentUser.uid,
                      displayName: displayNameController.text,
                      profession: professionController.text,
                      quote: quoteController.text,
                      avatarUrl: avatarController.text,
                    ).toMap(),
                  )
                  .then((value) {
                Navigator.pop(context);
              });
            }
          },
          child: const Text('Update'),
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
  }
}
