import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:test/test.dart';

void main() {
  group('ChatRoom', () {
    test('supports equality', () {
      expect(
        ChatRoom(header: ChatRoomHeader(id: 'test_id')),
        ChatRoom(header: ChatRoomHeader(id: 'test_id')),
      );
    });

    test('creates with unique ids by default', () {
      expect(
        ChatRoom(),
        isNot(ChatRoom()),
      );
    });
  });
}
