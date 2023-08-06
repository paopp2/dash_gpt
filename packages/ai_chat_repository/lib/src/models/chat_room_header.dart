import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
class ChatRoomHeader extends Equatable {
  ChatRoomHeader({
    String? id,
    String? title,
  })  : id = id ?? Uuid().v4(),
        title = title ?? 'New chat';

  final String id;
  final String? title;

  ChatRoomHeader copyWith({String? title}) {
    return ChatRoomHeader(
      id: id,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [id, title];

  @override
  String toString() => "ChatRoomHeader {id: $id, title: $title}";
}
