import 'package:chat_app/Model/MessageModel.dart';
import 'package:chat_app/Screens/ContactListing.dart';
import 'package:chat_app/Screens/IndividualPage.dart';
import 'package:chat_app/Socket/phoenix_channel.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {Key? key, required this.currentUser, required this.chatWithUser})
      : super(key: key);

  final Contact currentUser;
  final Contact chatWithUser;
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageModel> messages = [];
  PageController _pageController = PageController();

  void setMessage(String type, String message) {
    MessageModel messageModel = MessageModel(message: message, type: type);

    if (this.mounted) {
      setState(() {
        messages.add(messageModel);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    PhoenixChannelSocket.connect(
        onOpen: _onOpenSocket, onError: _onSocketError);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController?.dispose();
  }

  _onOpenSocket() async {
    print("socket connected successfully" + widget.currentUser.id.toString());

    bool isMessageDelivered = await PhoenixChannelSocket.join(
        "individual:" + widget.chatWithUser.id.toString(),
        widget.currentUser.id,
        widget.chatWithUser.id,
        onMessage: _onMessageSent,
        onError: _onMessageDeliverFail);

    print("Is Message Delivered Joined: $isMessageDelivered");

    bool isMessageReceived = await PhoenixChannelSocket.join(
        "individual:" + widget.currentUser.id.toString(),
        widget.currentUser.id,
        widget.chatWithUser.id,
        onMessage: _onMessageReceived,
        onError: _onMessageReceivedFail);

    print("Is Message Received Joined: $isMessageReceived");
  }

  // @TODO Figure out the steps to trigger this callback again
  // I was only able to trigger this callback once, but I was missing the error
  // parameter, therefore it threw an exception.
  _onSocketError(error) {
    print("socket error: $error");
  }

  _onMessageSent(payload, _ref, _joinRef) {
    print('message sent successfully: ' + payload.toString());
  }

  _onMessageDeliverFail(payload, ref, joinRef) {
    print("message delivery failed: " + payload.toString());
  }

  _onMessageReceived(payload, _ref, _joinRef) {
    print('message received successfully: ' + payload.toString());
    dynamic sentMessage = payload;
    if (sentMessage["targetId"] == widget.currentUser.id) {
      setMessage("received", sentMessage["message"]);
    }
  }

  _onMessageReceivedFail(payload, ref, joinRef) {
    print("message received failed: " + payload.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height - 185,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: ((context, index) =>
                    (messages[index].type == 'sent')
                        ? SentMessage(
                            messageModel: messages[index],
                          )
                        : ReceivedMessage(messageModel: messages[index]))),
          ),
        ),
        ChatInput(
          setMessage: (String type, String message) {
            setMessage(type, message);
          },
          chatWithUser: widget.chatWithUser,
          currentUser: widget.currentUser,
        ),
      ],
    );
  }
}

class ChatInput extends StatefulWidget {
  const ChatInput(
      {Key? key,
      required this.currentUser,
      required this.chatWithUser,
      required this.setMessage})
      : super(key: key);

  final Contact currentUser;
  final Contact chatWithUser;
  final Function(String, String) setMessage;
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  void sendMessage(String message, int sourceId, int targetId) async {
    bool isMessageDelivered = await PhoenixChannelSocket.push(
      message,
      "individual:" + widget.chatWithUser.id.toString(),
      widget.currentUser.id,
      widget.chatWithUser.id,
    );

    print("Is MessageDelivered : $isMessageDelivered");
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: TextFormField(
              controller: _controller,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type a message",
                  suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        onPressed: () {
                          widget.setMessage("sent", _controller.text);
                          sendMessage(_controller.text, widget.currentUser.id,
                              widget.chatWithUser.id);
                          _controller.clear();
                        },
                        icon: Icon(Icons.send))
                  ]),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5)),
            ),
          ),
        )
      ]),
    );
  }
}
