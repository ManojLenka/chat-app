import 'package:chat_app/Screens/ChooseUser.dart';
import 'package:chat_app/Screens/ContactListing.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(
  //   Center(
  //     child: Text('Hello, world!', textDirection: TextDirection.ltr),
  //   ),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: ChooseUser(),
    );
  }
}

class InitialRoute extends StatefulWidget {
  const InitialRoute(
      {required this.availableContacts, required this.currentUser, Key? key})
      : super(key: key);

  final Contact currentUser;
  final List<Contact> availableContacts;
  @override
  _InitialRouteState createState() => _InitialRouteState();
}

class _InitialRouteState extends State<InitialRoute> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat App',
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: '/',
        routes: {
          '/': (context) => ContactList(
                contacts: widget.availableContacts,
                currentUser: widget.currentUser,
              ), // MyHomePage(title: 'Chat App Home Page'),
          ExtractContactScreenArguments.routeName: (context) =>
              const ExtractContactScreenArguments(),
        });
  }
}
