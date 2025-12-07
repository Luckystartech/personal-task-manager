import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/core/theme/app_base.dart';
import 'package:personal_task_manager/features/task/presentation/screens/task_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PersonalTaskManagerApp()));
}

class PersonalTaskManagerApp extends StatelessWidget {
  const PersonalTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBase(
      debugShowCheckedModeBanner: false,
      child: TaskDashboardScreen(),
    );
  }
}
