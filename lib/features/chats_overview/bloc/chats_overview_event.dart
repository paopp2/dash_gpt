part of 'chats_overview_bloc.dart';

sealed class ChatsOverviewEvent extends Equatable {
  const ChatsOverviewEvent();

  @override
  List<Object> get props => [];
}

final class ChatsOverviewInitRequested extends ChatsOverviewEvent {}

final class ChatsOverviewRoomSelected extends ChatsOverviewEvent {
  const ChatsOverviewRoomSelected({required this.chatRoomId});
  final String chatRoomId;
}
