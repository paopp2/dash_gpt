import 'package:flutter/material.dart';

import 'chats_overview_view.dart';

class ChatsOverviewPage extends StatelessWidget {
  const ChatsOverviewPage({super.key});
  static String route = 'chats_overview_page_route';

  @override
  Widget build(BuildContext context) {
    return const ChatsOverviewView();
  }
}
