import 'package:ai_chat_repository/src/ai_chat_api/ai_chat_api.dart';
import 'package:ai_chat_repository/src/models/chat_room.dart';
import 'package:ai_chat_repository/src/models/chat_room_header.dart';
import 'package:ai_chat_repository/src/models/message.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class OpenAIChatApi implements AIChatApi {
  OpenAIChatApi({
    required OpenAI openAIInstance,
    required String openAIModel,
  })  : _openAI = openAIInstance,
        _openAIModel = openAIModel;

  final OpenAI _openAI;
  final String _openAIModel;
  final _chatRoomMapSubject =
      BehaviorSubject<Map<ChatRoomHeader, ChatRoom>>.seeded({});
  late final Stream<Map<ChatRoomHeader, ChatRoom>> chatRoomMapStream =
      _chatRoomMapSubject.stream;

  @override
  Stream<ChatRoom> chatRoomStream(String id) {
    return _chatRoomMapSubject
        .map((Map<ChatRoomHeader, ChatRoom> chatRoomMap) =>
            chatRoomMap.values.toList())
        .map((List<ChatRoom> chatRooms) =>
            chatRooms.firstWhere((chatRoom) => chatRoom.header.id == id))
        .asBroadcastStream();
  }

  @override
  Future<void> createNewChatRoom({String? id, String? title}) async {
    final currChatRoomMap = _chatRoomMapSubject.value;
    final newChatRoom = ChatRoom(header: ChatRoomHeader(id: id, title: title));
    _chatRoomMapSubject.add({
      ...currChatRoomMap,
      newChatRoom.header: newChatRoom,
    });
  }

  @override
  Stream<List<ChatRoomHeader>> getChatRoomHeaders() {
    return _chatRoomMapSubject
        .map((chatRoomMap) => chatRoomMap.keys.toList())
        .asBroadcastStream();
  }

  @override
  Future<void> sendMessage({
    required String chatRoomId,
    required String message,
  }) async {
    final userMessage = Message(sender: MessageSender.user, content: message);
    final chatRoom = await chatRoomStream(chatRoomId).first;
    final chatRoomWithUserMessage = chatRoom.withNewMessage(userMessage);
    updateChatRoom(chatRoomWithUserMessage);

    final chatRoomMessages = chatRoomWithUserMessage.messages;
    final aiReplyMessage = await getAiReplyMessage(chatRoomMessages);
    updateChatRoom(chatRoomWithUserMessage.withNewMessage(aiReplyMessage));
  }

  @visibleForTesting
  void updateChatRoom(ChatRoom chatRoom) {
    _chatRoomMapSubject.add({
      ..._chatRoomMapSubject.value,
      chatRoom.header: chatRoom,
    });
  }

  @visibleForTesting
  OpenAIChatCompletionChoiceMessageModel toOpenAIMessage(Message message) {
    return OpenAIChatCompletionChoiceMessageModel(
      role: switch (message.sender) {
        MessageSender.ai => OpenAIChatMessageRole.assistant,
        MessageSender.user => OpenAIChatMessageRole.user,
      },
      content: message.content,
    );
  }

  @visibleForTesting
  Future<Message> getAiReplyMessage(List<Message> chatMessages) async {
    final aiChatMessages = chatMessages.map(toOpenAIMessage).toList();

    OpenAIChatCompletionModel chatCompletion = await _openAI.chat.create(
      model: _openAIModel,
      messages: aiChatMessages,
    );

    return Message(
      sender: MessageSender.ai,
      content: chatCompletion.choices.first.message.content,
    );
  }
}
