import 'dart:async';

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
    final sendMessageCompleter = Completer<void>();
    final chatRoomChangesSubject = BehaviorSubject<ChatRoom>();

    final userMessage = Message(sender: MessageSender.user, content: message);
    final chatRoom = await chatRoomStream(chatRoomId).first;
    final chatRoomWithUserMessage = chatRoom.withNewMessage(userMessage);
    chatRoomChangesSubject.add(chatRoomWithUserMessage);

    getAIReplyMessageStream(chatRoomWithUserMessage.messages).listen(
      (aiReplyMessage) => chatRoomChangesSubject.add(
        chatRoomWithUserMessage.copyWith(
          messages: [...chatRoomWithUserMessage.messages, aiReplyMessage],
        ),
      ),
      onDone: () {
        chatRoomChangesSubject.close();
        sendMessageCompleter.complete();
      },
    );

    chatRoomChangesSubject.stream.listen(updateChatRoom);
    return sendMessageCompleter.future;
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
  Stream<Message> getAIReplyMessageStream(List<Message> chatMessages) {
    final aiChatMessages = chatMessages.map(toOpenAIMessage).toList();
    return _openAI.chat
        .createStream(model: _openAIModel, messages: aiChatMessages)
        .map((aiChatCompletion) => aiChatCompletion.choices.first.delta.content)
        .scan((aiReply, aiReplyDelta, _) => aiReply + (aiReplyDelta ?? ''), '')
        .map((aiReply) => Message(sender: MessageSender.ai, content: aiReply));
  }
}
