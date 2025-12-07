import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/core/theme/data/radius.dart';
import 'package:personal_task_manager/features/task/presentation/controllers/task_list_notifier.dart';
import 'package:personal_task_manager/features/task/presentation/widgets/filter_sheet.dart';
import 'package:personal_task_manager/features/task/presentation/widgets/task_search_delegate.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/widgets/base.dart';

class SearchAndFilter extends ConsumerWidget {
  const SearchAndFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;

    return Container(
      width: double.infinity,
      padding: const AppPadding(
        padding: AppEdgeInsets.symmetric(vertical: AppGapSize.regular),
      ).padding.toEdgeInsets(theme),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Removed menu icon as requested
          Expanded(
            child: GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: TaskSearchDelegate(ref));
              },
              child: Container(
                height: 48,
                padding: const AppEdgeInsets.all(
                  // horizontal: AppGapSize.semiBig,
                  AppGapSize.regular,
                ).toEdgeInsets(theme),
                decoration: BoxDecoration(
                  color: theme
                      .colors
                      .actionBarBackground, // or any background you prefer
                  borderRadius: const AppRadiusData.regular()
                      .asBorderRadius()
                      .regular,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colors.primary.withAlpha(12),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Icon(Icons.search, color: theme.colors.foreground),
                    const SizedBox(width: 12),
                    AppText.paragraph2(
                      'Search tasks...', // placeholder text
                      color: theme.colors.foreground,
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Consumer(
              builder: (context, ref, _) {
                final hasFilter = ref.watch(
                  taskListNotifierProvider.select((v) => v.hasFilter),
                );
                return Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme
                        .colors
                        .actionBarBackground, // or any background you prefer
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colors.primary.withAlpha(12),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Badge(
                      isLabelVisible: hasFilter,
                      smallSize: 8,
                      largeSize: 10,
                      child: Icon(
                        Icons.filter_list,
                        color: theme.colors.foreground,
                      ),
                    ),
                  ),
                );
              },
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: theme.colors.background,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                builder: (_) => const FilterSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}
