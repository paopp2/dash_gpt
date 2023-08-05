import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chats_overview_event.dart';
part 'chats_overview_state.dart';

class ChatsOverviewBloc extends Bloc<ChatsOverviewEvent, ChatsOverviewState> {
  ChatsOverviewBloc() : super(const ChatsOverviewState()) {
    on<ChatsOverviewEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
