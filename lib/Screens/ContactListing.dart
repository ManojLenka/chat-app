import 'package:chat_app/Screens/ChatPage.dart';
import 'package:flutter/material.dart';

class Contact {
  const Contact({required this.name, required this.id});

  final String name;
  final int id;
}

typedef NavigateToContact = Function(Contact name);

class ContactScreenArguments {
  final Contact currentUser;
  final Contact chatWithUser;

  ContactScreenArguments(this.currentUser, this.chatWithUser);
}

class ExtractContactScreenArguments extends StatelessWidget {
  const ExtractContactScreenArguments({super.key});

  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ContactScreenArguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.chatWithUser.name),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ChatPage(
            chatWithUser: args.chatWithUser,
            currentUser: args.currentUser,
          ),
          // Stack(
          //   children: [
          //     ChatPage(
          //         chatWithUser: args.chatWithUser,
          //         currentUser: args.currentUser),
          //     // ChatInput(
          //     //     chatWithUser: args.chatWithUser,
          //     //     currentUser: args.currentUser),
          //   ],
          // )),
        ));
  }
}

class ContactList extends StatefulWidget {
  const ContactList(
      {required this.contacts, required this.currentUser, super.key});

  final Contact currentUser;
  final List<Contact> contacts;

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _contacts = <Contact>{};

  void _showContactMessages(Contact contact) {
    Navigator.pushNamed(context, ExtractContactScreenArguments.routeName,
        arguments: ContactScreenArguments(widget.currentUser, contact));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat App'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: widget.contacts
              .map((c) => ContactListItem(
                  contact: c, navigateToContact: _showContactMessages))
              .toList(),
        ));
  }
}

class ContactListItem extends StatelessWidget {
  ContactListItem({
    required this.contact,
    required this.navigateToContact,
  }) : super(key: ObjectKey(contact));

  final Contact contact;
  final NavigateToContact navigateToContact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          navigateToContact(contact);
        },
        leading: CircleAvatar(
            backgroundColor: Colors.green, child: Text(contact.name[0])),
        title: Text(
          contact.name,
          style: const TextStyle(color: Colors.black54),
        ));
  }
}
