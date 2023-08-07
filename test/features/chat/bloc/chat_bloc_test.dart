import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dash_gpt/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAiChatRepository extends Mock implements AIChatRepository {}

void main() {
  final mockChatRoomUpdates = [
    ChatRoom(
      header: ChatRoomHeader(id: 'test_id_1', title: 'Title 1'),
      messages: const [],
      title: 'Title 1',
    ),
    ChatRoom(
      header: ChatRoomHeader(id: 'test_id_1', title: 'New Title 1'),
      messages: const [],
      title: 'New Title 1',
    ),
    ChatRoom(
      header: ChatRoomHeader(id: 'test_id_1', title: 'New Title 1'),
      messages: [Message(content: 'content', sender: MessageSender.user)],
      title: 'New Title 1',
    ),
  ];

  group('ChatBloc', () {
    late AIChatRepository mockAIChatRepository;

    ChatBloc buildBloc([String? chatRoomId]) {
      return ChatBloc(
        chatRoomId: chatRoomId,
        aiChatRepository: mockAIChatRepository,
      );
    }

    setUp(() {
      mockAIChatRepository = MockAiChatRepository();
      when(() {
        return mockAIChatRepository.deleteChatRoom(any());
      }).thenAnswer((_) async {});
      when(() {
        return mockAIChatRepository.sendMessage(
          chatRoomId: any(named: 'chatRoomId'),
          message: any(named: 'message'),
        );
      }).thenAnswer((_) async {});
      when(() {
        return mockAIChatRepository.createNewChatRoom(
          id: any(named: 'id'),
          title: any(named: 'title'),
        );
      }).thenAnswer((_) => Future.value(mockChatRoomUpdates.first));
      when(() {
        return mockAIChatRepository.chatRoomStream(any());
      }).thenAnswer((_) => Stream.fromIterable(mockChatRoomUpdates));
    });

    group('ChatRoomInitRequested', () {
      blocTest(
        "calls aiChatRepo.createNewChatRoom when chatId is null",
        setUp: () {
          when(() {
            return mockAIChatRepository.chatRoomStream(any());
          }).thenAnswer((_) => const Stream.empty());
          when(() => mockAIChatRepository.createNewChatRoom()).thenAnswer(
            (_) => Future.value(mockChatRoomUpdates.first),
          );
        },
        build: () => buildBloc(),
        act: (bloc) => bloc.add(ChatRoomInitRequested()),
        verify: (bloc) => verify(
          () => mockAIChatRepository.createNewChatRoom(),
        ).called(1),
      );

      blocTest(
        "doesn't call aiChatRepo.createNewChatRoom when has chatRoomId",
        build: () => buildBloc('test_chat_room_id'),
        act: (bloc) => bloc.add(ChatRoomInitRequested()),
        verify: (bloc) => verifyNever(
          () => mockAIChatRepository.createNewChatRoom(),
        ),
      );

      blocTest(
        "calls aiChatRepo.createNewChatRoom only when chatId is null",
        build: buildBloc,
        act: (bloc) => bloc.add(ChatRoomInitRequested()),
        verify: (bloc) => verify(
          () => mockAIChatRepository.createNewChatRoom(),
        ).called(1),
      );

      blocTest(
        'emits correct state for each chatRoom update',
        build: () => buildBloc('test_id_1'),
        setUp: () {
          when(() {
            return mockAIChatRepository.chatRoomStream('test_id_1');
          }).thenAnswer((_) => Stream.fromIterable(mockChatRoomUpdates));
        },
        act: (bloc) => bloc.add(ChatRoomInitRequested()),
        expect: () => [
          const ChatState(
            chatRoomTitle: 'Title 1',
            status: ChatRoomStatus.success,
          ),
          const ChatState(
            chatRoomTitle: 'New Title 1',
            status: ChatRoomStatus.success,
            messages: [],
          ),
          ChatState(
            chatRoomTitle: 'New Title 1',
            status: ChatRoomStatus.success,
            messages: mockChatRoomUpdates.last.messages,
          ),
        ],
      );
    });

    group('ChatMessageChanged', () {
      const msg1 = 'message1';
      const msg2 = 'message2';
      blocTest(
        'emits new state for each ChatMessageChanged event',
        build: buildBloc,
        seed: () => const ChatState(),
        act: (bloc) => bloc
          ..add(const ChatMessageChanged(message: msg1))
          ..add(const ChatMessageChanged(message: msg2)),
        expect: () => [
          const ChatState(messageToSend: msg1),
          const ChatState(messageToSend: msg2),
        ],
      );
    });

    group('ChatMessageSent', () {
      blocTest(
        'verify messageToSend reset back to empty string',
        build: () => buildBloc('test_id'),
        seed: () => const ChatState(messageToSend: 'initial'),
        act: (bloc) => bloc.add(ChatMessageSent()),
        expect: () => [const ChatState()],
      );

      blocTest(
        'verify calls aiChatRepository.sendMessage(messageToSend) once',
        build: () => buildBloc('test_id'),
        seed: () => const ChatState(messageToSend: 'to_send'),
        act: (bloc) => bloc.add(ChatMessageSent()),
        verify: (bloc) => verify(() => mockAIChatRepository.sendMessage(
              chatRoomId: any(named: 'chatRoomId'),
              message: 'to_send',
            )).called(1),
      );
    });
  });
}
