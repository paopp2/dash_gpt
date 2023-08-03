import '../models/models.dart';

abstract class AIChatApi {
  Future<void> sendMessage({
    required String chatRoomId,
    required String message,
  });

  Stream<List<ChatRoomHeader>> getChatRoomHeaders();

  Stream<ChatRoom> chatRoomStream(String id);

  Future<void> createNewChatRoom({String? id, String? title});
}
