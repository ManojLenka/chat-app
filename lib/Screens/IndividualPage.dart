import 'package:chat_app/Model/MessageModel.dart';
import 'package:chat_app/Socket/phoenix_channel.dart';
import 'package:flutter/material.dart';

class ReceivedMessage extends StatefulWidget {
  const ReceivedMessage({required this.messageModel, Key? key})
      : super(key: key);

  final MessageModel messageModel;
  @override
  _ReceivedMessageState createState() => _ReceivedMessageState();
}

class _ReceivedMessageState extends State<ReceivedMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 50,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Colors.grey[200],
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.messageModel.message,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class SentMessage extends StatefulWidget {
  const SentMessage({required this.messageModel, Key? key}) : super(key: key);

  final MessageModel messageModel;
  @override
  _SentMessageState createState() => _SentMessageState();
}

class _SentMessageState extends State<SentMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 50,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Colors.green[300],
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.messageModel.message,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
