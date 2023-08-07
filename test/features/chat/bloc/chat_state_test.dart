import 'package:dash_gpt/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatState', () {
    test('has the correct initial state', () {
      expect(
        const ChatState(),
        const ChatState(
          chatRoomTitle: 'New chat',
          messageToSend: '',
          status: ChatRoomStatus.loading,
          messages: [],
        ),
      );
    });

    test('supports equality', () {
      expect(const ChatState(), const ChatState());
      expect(
        const ChatState(
          chatRoomTitle: 'test_title',
          status: ChatRoomStatus.success,
          messageToSend: 'hello',
        ),
        const ChatState(
          chatRoomTitle: 'test_title',
          status: ChatRoomStatus.success,
          messageToSend: 'hello',
        ),
      );
    });
  });
}
