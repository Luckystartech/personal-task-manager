// lib/features/task/presentation/widgets/task_search_delegate.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/features/task/presentation/controllers/task_list_notifier.dart';
import 'package:personal_task_manager/features/task/presentation/screens/add_task_screen.dart';
import 'package:personal_task_manager/features/task/presentation/widgets/task_item.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/widgets/base.dart';

class TaskSearchDelegate extends SearchDelegate<void> {
  final WidgetRef ref;
  Timer? _debounce;

  TaskSearchDelegate(this.ref) : super(searchFieldLabel: 'Search tasks');

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = context.theme;

    final base = Theme.of(context);

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.colors.background,
        iconTheme: IconThemeData(color: theme.colors.foreground),
      ),
      primaryColor: theme.colors.primary,
      scaffoldBackgroundColor:
          theme.colors.background, // 🔥 background of results page
      inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
      textTheme: TextTheme(headlineMedium: theme.typography.title1),
      hintColor: theme.colors.primaryOpposite,
      primaryTextTheme: TextTheme(headlineMedium: theme.typography.title1),
    );
  }

  @override
  TextStyle? get searchFieldStyle {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return TextStyle(
      color: isDarkMode ? Color(0xFFfafbfe) : const Color(0xFF22315E),
    );
  }

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(taskListNotifierProvider.notifier).applySearch(q);
    });
  }

  @override
  void close(BuildContext context, void result) {
    _debounce?.cancel();
    ref.read(taskListNotifierProvider.notifier).applySearch('');
    super.close(context, result);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(taskListNotifierProvider);

        if (state.isLoading && state.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state.tasks.isEmpty) {
          return Center(child: AppText.paragraph2('No results'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final t = state.tasks[index];
            return TaskItem(
              key: ValueKey(t.id),
              task: t,
              onToggle: () {
                ref
                    .read(taskListNotifierProvider.notifier)
                    .toggleTaskCompletion(t.id);
              },
              onDelete: () {
                ref.read(taskListNotifierProvider.notifier).deleteTask(t.id);
              },
              onEdit: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AddTaskScreen(taskToEdit: t),
                  ),
                );

                if (!context.mounted) return;
                if (result == true) {
                  ref.read(taskListNotifierProvider.notifier).applySearch('');
                }
              },
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: state.tasks.length,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show live results as suggestions
    // _onQueryChanged(query);
    return Consumer(
      builder: (context, ref, _) {
        _onQueryChanged(query);
        return buildResults(context);
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            // ref.read(taskListNotifierProvider.notifier).clearFilters();
            query = '';
            ref.read(taskListNotifierProvider.notifier).applySearch('');
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }
}
