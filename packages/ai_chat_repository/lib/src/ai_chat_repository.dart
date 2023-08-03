import 'package:ai_chat_repository/src/ai_chat_api/ai_chat_api.dart';
import 'package:ai_chat_repository/src/models/chat_room.dart';
import 'package:ai_chat_repository/src/models/chat_room_header.dart';

class AIChatRepository implements AIChatApi {
  AIChatRepository({
    required AIChatApi aiChatApi,
  }) : _aiChatApi = aiChatApi;

  final AIChatApi _aiChatApi;

  @override
  Stream<ChatRoom> chatRoomStream(String id) {
    return _aiChatApi.chatRoomStream(id);
  }

  @override
  Future<void> createNewChatRoom({String? id, String? title}) {
    return _aiChatApi.createNewChatRoom();
  }

  @override
  Stream<List<ChatRoomHeader>> getChatRoomHeaders() {
    return _aiChatApi.getChatRoomHeaders();
  }

  @override
  Future<void> sendMessage({
    required String chatRoomId,
    required String message,
  }) {
    return _aiChatApi.sendMessage(
      chatRoomId: chatRoomId,
      message: message,
    );
  }
}
