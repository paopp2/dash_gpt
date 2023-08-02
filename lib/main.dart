import 'package:bloc/bloc.dart';
import 'package:dash_gpt/app/app_bloc_observer.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}
