part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class ChatRoomInitRequested extends ChatEvent {}

final class ChatMessageChanged extends ChatEvent {
  const ChatMessageChanged({required this.message});
  final String message;
}

final class ChatMessageSent extends ChatEvent {}
