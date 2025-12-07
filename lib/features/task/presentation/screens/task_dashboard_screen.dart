import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/features/task/presentation/controllers/task_list_notifier.dart';
import 'package:personal_task_manager/features/task/presentation/widgets/add_task_button.dart';
import 'package:personal_task_manager/features/task/presentation/widgets/app_title_header.dart';
import 'package:personal_task_manager/features/task/presentation/widgets/search_and_filter.dart';
import 'package:personal_task_manager/features/task/presentation/widgets/today_tasks_section.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/widgets/base.dart';

class TaskDashboardScreen extends StatelessWidget {
  const TaskDashboardScreen({super.key});

  bool _onScrollNotification(ScrollNotification notification, WidgetRef ref) {
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      // Check if we're near the bottom (within 200 pixels)
      if (metrics.pixels >= metrics.maxScrollExtent - 200) {
        // Load next page
        ref.read(taskListNotifierProvider.notifier).loadNextPage();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      backgroundColor: theme.colors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const AppEdgeInsets.symmetric(
            horizontal: AppGapSize.big,
          ).toEdgeInsets(theme),
          child: Column(
            children: [
              const AppGap.small(),
              const AppTitleHeader(),
              const AppGap.small(),
              const SearchAndFilter(),
              Consumer(
                builder: (context, ref, _) {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        ref.read(taskListNotifierProvider.notifier).refresh();
                        // Add small delay for UX
                        await Future.delayed(const Duration(milliseconds: 500));
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) =>
                            _onScrollNotification(notification, ref),
                        child: const SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // AppGap.big(),
                              TodayTasksSection(),
                              AppGap.big(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const AddTaskButton(),
    );
  }
}
