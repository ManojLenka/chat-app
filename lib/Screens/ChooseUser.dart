import 'package:chat_app/Screens/ContactListing.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key}) : super(key: key);

  @override
  _ChooseUserState createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
  List<Contact> contacts = [
    Contact(name: 'Alpha', id: 1),
    Contact(name: 'Beta', id: 2),
    Contact(name: 'Gamma', id: 3),
  ];

  navigateToHomepage(Contact c) {
    contacts.removeWhere((element) => element.id == c.id);
    List<Contact> availableContacts = contacts;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (builder) => InitialRoute(
                  availableContacts: availableContacts,
                  currentUser: c,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login with user'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: contacts
              .map((c) => ContactListItem(
                  contact: c, navigateToContact: navigateToHomepage))
              .toList(),
        ));
  }
}
