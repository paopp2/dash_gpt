import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:dash_gpt/app/app_bloc_observer.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  OpenAI.apiKey = const String.fromEnvironment('OPEN_AI_API_KEY');

  final openAiChatApi = OpenAIChatApi(
    openAIChat: OpenAI.instance.chat,
    openAIModel: "gpt-3.5-turbo",
  );

  runApp(
    App(AIChatRepository(aiChatApi: openAiChatApi)),
  );
}
