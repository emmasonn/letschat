import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lets_chat/utils/phone_number_util.dart';
import '../../../models/user.dart' as app;
import '../../../utils/common/widgets/helper_widgets.dart';
import '../../../utils/constants/routes_constants.dart';
import '../../../utils/constants/string_constants.dart';

final selectReceiverContactsRepositoryProvider = Provider(
  (ref) => SelectReceiverContactsRepository(FirebaseFirestore.instance),
);

class SelectReceiverContactsRepository {
  SelectReceiverContactsRepository(FirebaseFirestore firestore)
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  /// invoke to Get all contacts (fully fetched)
  Future<List<Contact>> getReceiverContacts() async {
    List<Contact> contactsList = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contactsList = await FlutterContacts.getContacts(
          withPhoto: true,
          withProperties: true,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    return contactsList;
  }

  ///search contacts on firebase to and
  ///and filter the ones that has account with us.
  Future<List<app.User>> getRegisteredContact(BuildContext context) async {
    //collects and process all the users contact to a single list a
    final uPhones = (await getReceiverContacts()).map((contact) {
      String number = contact.phones[0].number.replaceAll(' ', '');
      return processNumber(number);
    }).toList();

    final userDocs = await _firestore
        .collection(StringsConsts.usersCollection)
        .where('phoneNumber', whereIn: uPhones)
        .get();

    return userDocs.docs.map((userDoc) {
      return app.User.fromMap(userDoc.data());
    }).toList();
  }

  /// invoke to select specific user if it exists
  Future<void> selectReceiverContact(
    bool mounted,
    BuildContext context, {
    required String number,
  }) async {
    bool isFound = false;
    final userCollection =
        await _firestore.collection(StringsConsts.usersCollection).get();

    for (var document in userCollection.docs) {
      app.User receiverUser = app.User.fromMap(document.data());

      if (number == receiverUser.phoneNumber) {
        isFound = true;

        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.chatScreen,
          arguments: <String, Object>{
            StringsConsts.username: receiverUser.name,
            StringsConsts.userId: receiverUser.uid,
            StringsConsts.profilePic: receiverUser.profilePic!,
            StringsConsts.isGroupChat: false,
          },
        );
      }
    }

    if (!isFound) {
      if (!mounted) return;
      showSnackBar(context, content: "User doesn't exist in this app");
    }
  }
}
