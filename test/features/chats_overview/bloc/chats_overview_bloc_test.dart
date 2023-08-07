import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dash_gpt/features/chats_overview/chats_overview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAiChatRepository extends Mock implements AIChatRepository {}

void main() {
  final List<ChatRoomHeader> mockChatRoomHeaders = [
    ChatRoomHeader(id: 'test_1', title: 'test_1'),
    ChatRoomHeader(id: 'test_2', title: 'test_2'),
    ChatRoomHeader(id: 'test_3', title: 'test_3'),
  ];

  group('ChatsOverviewBloc', () {
    late AIChatRepository mockAIChatRepository;

    ChatsOverviewBloc buildBloc() {
      return ChatsOverviewBloc(
        aiChatRepository: mockAIChatRepository,
      );
    }

    setUp(() {
      mockAIChatRepository = MockAiChatRepository();
    });

    group('ChatsOverviewInitRequested', () {
      blocTest(
        'Updates state.chatRooms on getChatRoomHeaders event',
        build: buildBloc,
        setUp: () => when(
          mockAIChatRepository.getChatRoomHeaders,
        ).thenAnswer(
          (_) => Stream.fromIterable(
            List.generate(
              mockChatRoomHeaders.length,
              (i) => mockChatRoomHeaders.sublist(0, i + 1),
            ),
          ),
        ),
        act: (bloc) => bloc.add(ChatsOverviewInitRequested()),
        expect: () => List.generate(
          mockChatRoomHeaders.length,
          (i) => ChatsOverviewState(
            status: ChatsOverviewStatus.success,
            chatRooms: mockChatRoomHeaders.sublist(0, i + 1),
          ),
        ),
      );
    });

    group('ChatsOverviewRoomSelected', () {
      blocTest(
        'updates selectedChatRoomId with event.chatRoomId',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const ChatsOverviewRoomSelected(chatRoomId: 'test_id'),
        ),
        expect: () => [
          const ChatsOverviewState(selectedChatRoomId: 'test_id'),
        ],
      );
    });
  });
}
