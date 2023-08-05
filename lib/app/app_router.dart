import 'package:dash_gpt/features/chat/view/chat_page.dart';
import 'package:dash_gpt/features/chats_overview/chats_overview_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static get instance {
    return GoRouter(
      routes: [
        ChatsOverviewPage.route,
        ChatPage.route,
      ],
    );
  }
}
