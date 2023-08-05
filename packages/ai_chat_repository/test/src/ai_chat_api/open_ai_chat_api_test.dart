import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:clock/clock.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// Will need the OpenAIChat interface to allow mocking
// ignore: implementation_imports
import 'package:dart_openai/src/instance/chat/chat.dart' show OpenAIChat;

const testOpenAIModel = 'test_open_ai_model';

class MockOpenAIChat extends Mock implements OpenAIChat {}

void main() {
  late OpenAIChatApi openAIChatAPI;
  late OpenAIChat mockOpenAIChat;

  setUp(() {
    mockOpenAIChat = MockOpenAIChat();

    openAIChatAPI = OpenAIChatApi(
      openAIChat: mockOpenAIChat,
      openAIModel: testOpenAIModel,
    );
  });

  group('OpenAIChatApi', () {
    group('chatRoomStream', () {
      test('is BroadcastStream', () {
        openAIChatAPI.chatRoomMapSubject.add(_getMockChatRoomMap);
        final chatRoomStream = openAIChatAPI.chatRoomStream('0');
        expect(chatRoomStream.isBroadcast, true);
      });

      test('is of type Stream<ChatRoom>', () {
        openAIChatAPI.chatRoomMapSubject.add(_getMockChatRoomMap);
        final chatRoomStream = openAIChatAPI.chatRoomStream('0');
        expect(chatRoomStream, isA<Stream<ChatRoom>>());
      });

      test('returns chatRoom stream with id', () async {
        openAIChatAPI.chatRoomMapSubject.add(_getMockChatRoomMap);
        final chatRoomStream = openAIChatAPI.chatRoomStream('2');
        final chatRoom = await chatRoomStream.first;
        final expectedChatRoom = _getMockChatRoomMap.values.toList()[2];
        expect(chatRoom, expectedChatRoom);
      });
    });
    group('createNewChatRoom', () {
      test('adds new chat room from id and title', () {
        final firstEntry = _getMockChatRoomMap.entries.first;

        openAIChatAPI.chatRoomMapSubject.add(
          {firstEntry.key: firstEntry.value},
        );
        expect(openAIChatAPI.chatRoomMapSubject.value.length, 1);

        final newChatRoom = ChatRoom(
          header: ChatRoomHeader(id: 'test id'),
          title: 'test title',
        );
        openAIChatAPI.createNewChatRoom(
          id: newChatRoom.header.id,
          title: newChatRoom.header.title,
        );
        final lastAddedChatRoom =
            openAIChatAPI.chatRoomMapSubject.value.values.last;
        expect(lastAddedChatRoom, newChatRoom);
        expect(openAIChatAPI.chatRoomMapSubject.value.length, 2);
      });
    });
    group('getChatRoomHeaders', () {
      test('maps the chatRoomMap to a stream of its chatRoomHeaders', () async {
        openAIChatAPI.chatRoomMapSubject.add(_getMockChatRoomMap);
        final expectedValue =
            _getMockChatRoomMap.entries.map((e) => e.value.header).toList();
        final actualValue = await openAIChatAPI.getChatRoomHeaders().first;
        expect(actualValue, expectedValue);
      });
    });

    group('sendMessage', () {
      test(
        "initially updates chatRoom with userMessage built from message, then updates with message from AI reply",
        () {
          when(() => mockOpenAIChat.createStream(
                model: any(named: 'model'),
                messages: any(named: 'messages'),
              )).thenAnswer(
            (_) => Stream.fromIterable(_mockChatCompletion(1)),
          );

          withClock(Clock.fixed(DateTime(2019)), () {
            final initialChatRoomMap = _getMockChatRoomMap.entries.first;
            final initialMap = {
              initialChatRoomMap.key: initialChatRoomMap.value
            };
            openAIChatAPI.chatRoomMapSubject.add(initialMap);
            openAIChatAPI.sendMessage(chatRoomId: '0', message: 'test_message');

            expect(
              openAIChatAPI.chatRoomMapSubject,
              emitsInOrder([
                emitsThrough(initialMap),
                emitsThrough({
                  ...initialMap,
                  initialChatRoomMap.key:
                      initialChatRoomMap.value.withNewMessage(
                    Message(
                      content: 'test_message',
                      sender: MessageSender.user,
                    ),
                  ),
                }),
                emitsThrough({
                  ...initialMap,
                  initialChatRoomMap.key: initialChatRoomMap.value
                      .withNewMessage(
                        Message(
                          content: 'test_message',
                          sender: MessageSender.user,
                        ),
                      )
                      .withNewMessage(Message(
                        content: 'delta 0',
                        sender: MessageSender.ai,
                      )),
                }),
              ]),
            );
          });
        },
      );
    });

    group('updateChatRoom', () {
      test('updates the chatRoom with same header to a new value', () {
        openAIChatAPI.chatRoomMapSubject.add(_getMockChatRoomMap);
        final initialLength = _getMockChatRoomMap.values.length;
        final expectedPrevChatRoom = _getMockChatRoomMap.values.toList().last;
        final actualPrevChatRoom =
            openAIChatAPI.chatRoomMapSubject.value.values.toList().last;
        expect(expectedPrevChatRoom, actualPrevChatRoom);

        final expectedUpdatedChatRoom = actualPrevChatRoom.copyWith(messages: [
          ...actualPrevChatRoom.messages,
          Message(
            content: 'new content',
            sender: MessageSender.user,
          ),
        ]);
        openAIChatAPI.updateChatRoom(expectedUpdatedChatRoom);
        final actualUpdatedChatRoom =
            openAIChatAPI.chatRoomMapSubject.value.values.toList().last;
        expect(expectedUpdatedChatRoom, actualUpdatedChatRoom);
        expect(
          initialLength,
          openAIChatAPI.chatRoomMapSubject.value.values.length,
        );
      });
    });

    group('toOpenAIMessage', () {
      final testUserMessage = Message(
        content: 'user_test_content',
        sender: MessageSender.user,
      );
      final testAIMessage = Message(
        content: 'ai_test_content',
        sender: MessageSender.ai,
      );

      test('matches content', () {
        final openAiMessage = openAIChatAPI.toOpenAIMessage(testUserMessage);
        expect(openAiMessage.content, testUserMessage.content);
      });
      test('maps to correct openAI role', () {
        final aiOpenAiMessage = openAIChatAPI.toOpenAIMessage(testAIMessage);
        final userOpenAiMessage =
            openAIChatAPI.toOpenAIMessage(testUserMessage);

        expect(aiOpenAiMessage.role, OpenAIChatMessageRole.assistant);
        expect(userOpenAiMessage.role, OpenAIChatMessageRole.user);
      });
    });

    group('getAIReplyMessageStream', () {
      test('openAI.createStream called once', () {
        when(() => mockOpenAIChat.createStream(
              model: any(named: 'model'),
              messages: any(named: 'messages'),
            )).thenAnswer(
          (_) => Stream.fromIterable(_mockChatCompletion(1)),
        );

        openAIChatAPI.getAIReplyMessageStream([]).listen((event) {});
        verify(() => mockOpenAIChat.createStream(
              model: any(named: 'model'),
              messages: any(named: 'messages'),
            )).called(1);
      });

      test('API model mapped correctly to Message', () async {
        final mockCompletion = _mockChatCompletion(1);
        final aiResponse = mockCompletion.first.choices.first;

        when(() => mockOpenAIChat.createStream(
              model: any(named: 'model'),
              messages: any(named: 'messages'),
            )).thenAnswer(
          (_) => Stream.fromIterable(mockCompletion),
        );

        final aiReplyMessage =
            await openAIChatAPI.getAIReplyMessageStream([]).first;

        expect(aiResponse.delta.content, aiReplyMessage.content);
        expect(aiReplyMessage.sender, MessageSender.ai);
      });
      test('scan accumulates the delta content events received', () async {
        final mockCompletion = _mockChatCompletion(3);
        final expectedAccumulatedMessageContent = mockCompletion.fold(
          '',
          (prev, completion) =>
              prev + (completion.choices.first.delta.content ?? ''),
        );

        when(() => mockOpenAIChat.createStream(
              model: any(named: 'model'),
              messages: any(named: 'messages'),
            )).thenAnswer(
          (_) => Stream.fromIterable(mockCompletion),
        );

        final lastReplyMessage =
            await openAIChatAPI.getAIReplyMessageStream([]).last;

        expect(lastReplyMessage.content, expectedAccumulatedMessageContent);
      });
    });
  });
}

List<OpenAIStreamChatCompletionModel> _mockChatCompletion(int numCompletions) {
  return List.generate(
      numCompletions,
      (i) => OpenAIStreamChatCompletionModel(
            id: 'id',
            choices: [_generateMockCompletionChoices(numCompletions)[i]],
            created: DateTime(2019),
          ));
}

List<OpenAIStreamChatCompletionChoiceModel> _generateMockCompletionChoices(
  int count,
) {
  return List.generate(
    count,
    (i) => OpenAIStreamChatCompletionChoiceModel(
      delta: OpenAIStreamChatCompletionChoiceDeltaModel(
        content: 'delta $i',
        role: 'assistant',
      ),
      finishReason: 'finishReason $i',
      index: i,
    ),
  );
}

List<ChatRoom> get _getMockChatRooms => List.generate(
      5,
      (i) => ChatRoom(header: ChatRoomHeader(id: '$i'), title: 'title $i'),
    );

Map<String, ChatRoom> get _getMockChatRoomMap =>
    {for (final chatRoom in _getMockChatRooms) chatRoom.header.id: chatRoom};
