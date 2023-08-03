import 'package:equatable/equatable.dart';

enum MessageSender { ai, user }

class Message extends Equatable {
  Message({
    required this.content,
    required this.sender,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc();

  final String content;
  final MessageSender sender;
  final DateTime createdAt;

  @override
  List<Object?> get props => [content, sender];

  @override
  String toString() => "Message {sender: $sender, content: $content}";
}
