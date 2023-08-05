import 'package:dash_gpt/features/chat/view/chat_page.dart';
import 'package:dash_gpt/features/chats_overview/view/chats_overview_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static get instance {
    return GoRouter(
      routes: [
        GoRoute(
          name: ChatsOverviewPage.route,
          path: '/',
          builder: (context, state) => const ChatsOverviewPage(),
          routes: [
            GoRoute(
              name: ChatPage.route,
              path: 'chat/:id',
              builder: (context, state) => ChatPage(
                chatId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
