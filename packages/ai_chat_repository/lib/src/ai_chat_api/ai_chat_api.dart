import '../models/models.dart';

abstract class AIChatApi {
  Future<void> sendMessage({
    required String chatRoomId,
    required String message,
  });

  Stream<List<ChatRoomHeader>> getChatRoomHeaders();

  Stream<ChatRoom> chatRoomStream(String id);

  Future<ChatRoom> createNewChatRoom({String? id, String? title});

  Future<void> deleteChatRoom(String id);
}
