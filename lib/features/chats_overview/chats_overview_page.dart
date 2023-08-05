import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'chats_overview_view.dart';

class ChatsOverviewPage extends StatelessWidget {
  const ChatsOverviewPage({super.key});

  static GoRoute get route {
    return GoRoute(
      name: 'chats_overview_page',
      path: '/',
      builder: (context, state) => const ChatsOverviewPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ChatsOverviewView();
  }
}
