part of 'chats_overview_bloc.dart';

enum ChatsOverviewStatus { loading, success, failure }

final class ChatsOverviewState extends Equatable {
  const ChatsOverviewState({
    this.status = ChatsOverviewStatus.loading,
    this.selectedChatRoomId,
    this.chatRooms = const <ChatRoomHeader>[],
  });

  final ChatsOverviewStatus status;
  final String? selectedChatRoomId;
  final List<ChatRoomHeader> chatRooms;

  ChatsOverviewState copyWith({
    ChatsOverviewStatus? status,
    String? selectedChatRoomId,
    List<ChatRoomHeader>? chatRooms,
  }) {
    return ChatsOverviewState(
      status: status ?? this.status,
      selectedChatRoomId: selectedChatRoomId ?? this.selectedChatRoomId,
      chatRooms: chatRooms ?? this.chatRooms,
    );
  }

  @override
  List<Object> get props => [status, selectedChatRoomId ?? '~', chatRooms];
}
