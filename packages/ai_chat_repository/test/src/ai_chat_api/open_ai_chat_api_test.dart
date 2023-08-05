import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:ai_chat_repository/src/ai_chat_api/open_ai_chat_api.dart';
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
  final mockOpenAIChat = MockOpenAIChat();

  setUp(() {
    openAIChatAPI = OpenAIChatApi(
      openAIChat: mockOpenAIChat,
      openAIModel: testOpenAIModel,
    );
  });

  group('OpenAIChatApi', () {
    group('chatRoomStream', () {
      test('is BroadcastStream', () {});
      test('returns chatRoom stream with id', () {});
    });
    group('createNewChatRoom', () {});
    group('getChatRoomHeaders', () {});
    group('sendMessage', () {});
    group('updateChatRoom', () {});
    group('toOpenAIMessage', () {});
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
