import '../models/models.dart';

abstract class AIChatApi {
  Future<void> sendMessage({
    required String chatRoomId,
    required Message message,
  });

  Future<List<ChatRoomHeader>> getChatRooms();

  Stream<ChatRoom> chatRoomStream(String id);

  Future<void> createNewChatRoom(String title);
}
