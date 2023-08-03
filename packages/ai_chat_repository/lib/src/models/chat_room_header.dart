import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class ChatRoomHeader extends Equatable {
  ChatRoomHeader({
    this.title = '',
  }) : id = Uuid().v4();

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];

  @override
  String toString() => "ChatRoomHeader {id: $id, title: $title}";
}
