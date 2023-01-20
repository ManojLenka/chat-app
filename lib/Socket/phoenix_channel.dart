// import 'package:echo/http_service.dart';
import 'package:phoenix_wings/phoenix_wings.dart';

class PhoenixChannelSocket {
  static PhoenixSocket _socket =
      PhoenixSocket("ws://10.0.2.2:4000/socket/websocket");

  static Map<String, PhoenixChannel> _channels = {};

  static connect({onOpen, onError}) async {
    _socket.onOpen(onOpen);
    _socket.onError(onError);
    await _socket.connect();
  }

  static Future<bool> join(String channelName, int sourceId, int targetId,
      {onMessage, onError}) async {
    // This check needs to be the first, to be able to resume after app looses
    // network and reestablishes the socket connection.
    if (_socket != null && !_socket.isConnected) {
      print(
          "Phoenix Channel: Trying to reconnect to the socket. Poor Network??? Invalid or missing Approov token???");
      return false;
    }

    if (_socket == null) {
      print(
          "Phoenix Channel: No socket connection. No network??? Invalid or missing Approov token???");
      return false;
    }

    // Only join if not already joined.
    if (_channels != null && _channels[channelName] != null) {
      return true;
    }

    final PhoenixChannel _channel = _socket
        .channel(channelName, {"sourceId": sourceId, "targetId": targetId});

    // Setup listeners for channel events
    _channel.on(channelName, onMessage);
    _channel.onError(onError);

    // Make the request to the server to join the channel
    _channel.join();

    _channels[channelName] = _channel;

    return true;
  }

  static Future<bool> push(
      String message, String channelName, int sourceId, int targetId) async {
    if (_channels == null || _channels[channelName] == null) {
      print("Phoenix Channel: Unknown channel ${channelName}");
      return false;
    }

    Map payload = {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId
    };
    payload["message"] = message;

    _channels[channelName]?.push(event: channelName, payload: payload);

    return true;
  }
}
