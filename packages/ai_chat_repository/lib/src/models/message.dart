import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum MessageSender { ai, user }

@immutable
class Message extends Equatable {
  Message({
    required this.content,
    required this.sender,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? clock.now().toUtc();

  final String content;
  final MessageSender sender;
  final DateTime createdAt;

  @override
  List<Object?> get props => [content, sender, createdAt];

  @override
  String toString() => "Message {sender: $sender, content: $content}";
}
