import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/features/task/data/models/task_query.dart';
import 'package:personal_task_manager/features/task/data/repository/task_repository.dart';
import 'package:personal_task_manager/features/task/presentation/controllers/task_list_notifier.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/widgets/base.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  TaskQuery _localQuery = TaskQuery.empty;

  // date range / single date
  DateTime? _singleDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  bool? _completion; // null = both
  bool _newestFirst = true;

  @override
  void initState() {
    super.initState();
    final repoQuery = ref.read(taskRepositoryProvider).currentQuery;
    _localQuery = repoQuery;
    _singleDate = repoQuery.filterDate;
    _rangeStart = repoQuery.rangeStart;
    _rangeEnd = repoQuery.rangeEnd;
    _completion = repoQuery.isCompleted;
    _newestFirst = repoQuery.sortDescending;
  }

  void _apply() {
    final q = TaskQuery(
      searchQuery: _localQuery.searchQuery,
      isCompleted: _completion,
      filterDate: _singleDate,
      rangeStart: _rangeStart,
      rangeEnd: _rangeEnd,
      sortDescending: _newestFirst,
    );
    ref.read(taskListNotifierProvider.notifier).applyFilter(q);
    Navigator.of(context).pop();
  }

  void _clear() async {
    await ref
        .read(taskListNotifierProvider.notifier)
        .applyFilter(TaskQuery.empty);
    ref.read(taskListNotifierProvider.notifier).clearFilter();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickSingleDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _singleDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _singleDate = picked;
        _rangeStart = null;
        _rangeEnd = null;
      });
    }
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: _rangeStart != null && _rangeEnd != null
          ? DateTimeRange(start: _rangeStart!, end: _rangeEnd!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _rangeStart = picked.start;
        _rangeEnd = picked.end;
        _singleDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SafeArea(
      child: Padding(
        padding: AppEdgeInsets.all(AppGapSize.regular).toEdgeInsets(theme),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.title3('Filters'),
                TextButton(
                  onPressed: _clear,
                  child: const AppText.paragraph2('Clear'),
                ),
              ],
            ),
            AppGap.big(),
            // Completion filter
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.paragraph2('Completion'),
                Row(
                  children: [
                    ChoiceChip(
                      label: const AppText.paragraph2('Both'),
                      selected: _completion == null,
                      onSelected: (_) => setState(() => _completion = null),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const AppText.paragraph2('Completed'),
                      selected: _completion == true,
                      onSelected: (_) => setState(() => _completion = true),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const AppText.paragraph2('Uncompleted'),
                      selected: _completion == false,
                      onSelected: (_) => setState(() => _completion = false),
                    ),
                  ],
                ),
              ],
            ),
            AppGap.big(),
            // Date filter
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.paragraph2('Date'),
                  AppGap.small(),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _singleDate = DateTime.now();
                            _rangeStart = null;
                            _rangeEnd = null;
                          });
                        },
                        child: const Text('Only Today'),
                      ),
                      OutlinedButton(
                        onPressed: _pickSingleDate,
                        child: AppText.paragraph2(
                          _singleDate == null
                              ? 'Choose date'
                              : _singleDate!.toLocal().toString().split(' ')[0],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _pickRange,
                        child: AppText.paragraph2(
                          _rangeStart == null
                              ? 'Choose range'
                              : '${_rangeStart!.toLocal().toString().split(' ')[0]} → ${_rangeEnd!.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppGap.big(),
            // Sort
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.paragraph2('Sort'),
                Row(
                  children: [
                    ChoiceChip(
                      label: const AppText.paragraph2('Newest'),
                      selected: _newestFirst,
                      onSelected: (_) => setState(() => _newestFirst = true),
                    ),
                    AppGap.small(),
                    ChoiceChip(
                      label: const AppText.paragraph2('Oldest'),
                      selected: !_newestFirst,
                      onSelected: (_) => setState(() => _newestFirst = false),
                    ),
                  ],
                ),
              ],
            ),
            AppGap.big(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const AppText.paragraph2('Cancel'),
                  ),
                ),
                AppGap.small(),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _apply,
                    child: const AppText.paragraph2('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
