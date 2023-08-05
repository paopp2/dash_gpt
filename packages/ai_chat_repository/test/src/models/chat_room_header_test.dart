import 'package:ai_chat_repository/src/models/chat_room_header.dart';
import 'package:test/test.dart';

void main() {
  group('ChatRoomHeader', () {
    test('supports equality', () {
      expect(
        ChatRoomHeader(id: 'test_id', title: 'test_title'),
        ChatRoomHeader(id: 'test_id', title: 'test_title'),
      );
    });

    test('creates with unique ids by default', () {
      expect(ChatRoomHeader(), isNot(ChatRoomHeader()));
    });
  });
}
