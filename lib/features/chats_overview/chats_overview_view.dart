import 'package:dash_gpt/features/chat/view/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatsOverviewView extends StatelessWidget {
  const ChatsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ChatsOverview Page',
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () => context.goNamed(
              ChatPage.route.name!,
              pathParameters: {'id': 'test_id'},
            ),
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }
}
