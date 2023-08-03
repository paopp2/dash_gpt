import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
class ChatRoomHeader extends Equatable {
  ChatRoomHeader({
    String? id,
    this.title = '',
  }) : id = id ?? Uuid().v4();

  final String id;
  final String? title;

  @override
  List<Object?> get props => [id, title];

  @override
  String toString() => "ChatRoomHeader {id: $id, title: $title}";
}
