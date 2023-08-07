part of 'chats_overview_bloc.dart';

enum ChatsOverviewStatus { loading, success, failure }

final class ChatsOverviewState extends Equatable {
  const ChatsOverviewState({
    this.status = ChatsOverviewStatus.loading,
    this.selectedChatRoomId,
    this.chatRooms = const <ChatRoomHeader>[],
    this.chatRoomsDeletionInProgress = const {},
  });

  final ChatsOverviewStatus status;
  final String? selectedChatRoomId;
  final List<ChatRoomHeader> chatRooms;
  final Set<String> chatRoomsDeletionInProgress;

  ChatsOverviewState copyWith({
    ChatsOverviewStatus? status,
    String? selectedChatRoomId,
    List<ChatRoomHeader>? chatRooms,
    Set<String>? chatRoomsDeletionInProgress,
  }) {
    return ChatsOverviewState(
      status: status ?? this.status,
      selectedChatRoomId: selectedChatRoomId ?? this.selectedChatRoomId,
      chatRooms: chatRooms ?? this.chatRooms,
      chatRoomsDeletionInProgress:
          chatRoomsDeletionInProgress ?? this.chatRoomsDeletionInProgress,
    );
  }

  ChatsOverviewState withChatRoomDeleteInProgress(String id) {
    return copyWith(
      chatRoomsDeletionInProgress: {...chatRoomsDeletionInProgress, id},
    );
  }

  ChatsOverviewState withChatRoomDeleteInProgressRemoved(String id) {
    return copyWith(
      chatRoomsDeletionInProgress: {...chatRoomsDeletionInProgress}..remove(id),
    );
  }

  @override
  List<Object> get props => [
        status,
        selectedChatRoomId ?? '~',
        chatRooms,
        chatRoomsDeletionInProgress,
      ];
}
