class MessageModel {
  String type;
  String message;

  MessageModel({required this.message, required this.type});
}

class MessagePayload {
  String message;
  int sourceId;
  int targetId;

  MessagePayload(
      {required this.message, required this.sourceId, required this.targetId});
}
