import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/core/theme/app_theme.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';
import 'package:personal_task_manager/features/task/presentation/controllers/task_form_notifier.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/utils/ui_helper.dart';
import 'package:personal_task_manager/shared/widgets/base.dart';

part 'package:personal_task_manager/features/task/presentation/screens/add_task_screen_helpers.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final Task? taskToEdit; // Null for create, Task for edit

  const AddTaskScreen({super.key, this.taskToEdit});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen>
    with AddTaskScreenHelpers {
  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data for edit mode
    _titleController = TextEditingController(
      text: widget.taskToEdit?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.taskToEdit?.description ?? '',
    );

    // Initialize date/time for edit mode
    if (widget.taskToEdit != null) {
      _selectedDate = widget.taskToEdit!.taskDate;
      _selectedTime = TimeOfDay(
        hour: widget.taskToEdit!.taskTime.hour,
        minute: widget.taskToEdit!.taskTime.minute,
      );
    }

    // Add listeners to track form changes
    _titleController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final state = ref.watch(taskFormNotifierProvider);
    final isEditMode = widget.taskToEdit != null;

    // Listen for success/error states
    ref.listen<TaskFormState>(taskFormNotifierProvider, (previous, next) {
      if (next.error != null) {
        _showErrorSnackBar(next.error!);
        ref.read(taskFormNotifierProvider.notifier).clearError();
      }

      if (next.isSuccess) {
        _showSuccessSnackBar(next.successMessage ?? 'Success');
        // Mark form as clean before navigation
        _isFormDirty = false;
        // Small delay to show success message
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            Navigator.pop(context, true); // Return true to indicate success
          }
        });
      }
    });

    return PopScope(
      canPop: !_isFormDirty,
      onPopInvoked: (didPop) async {
        if (!didPop && _isFormDirty) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures taps on empty space count
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: theme.colors.actionBarBackground,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: theme.colors.actionBarBackground,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: theme.colors.foreground),
              onPressed: () async {
                if (_isFormDirty) {
                  final shouldPop = await _onWillPop();
                  if (shouldPop && context.mounted) {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            title: AppText.title3(isEditMode ? 'Edit task' : 'Add new task'),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: theme.spacing.asInsets().regular,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppGap.semiSmall(),
                    _buildLabel('Title', theme),
                    AppGap.semiSmall(),
                    _buildTextField(
                      controller: _titleController,
                      theme: theme,
                      errorText: _titleError,
                      enabled: !state.isLoading,
                      hintText: 'Task name...',
                      maxLength: 30,
                    ),
                    AppGap.semiBig(),
                    _buildLabel('Description (Optional)', theme),
                    AppGap.semiSmall(),
                    _buildTextField(
                      controller: _descriptionController,
                      theme: theme,
                      maxLines: 5,
                      enabled: !state.isLoading,
                      hintText: 'Describe your task...',
                    ),
                    AppGap.semiBig(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Date', theme),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: state.isLoading ? null : _selectDate,
                                child: _buildDateTimeField(
                                  _formatDate(_selectedDate),
                                  Icons.calendar_today,
                                  theme,
                                  isSelected: _selectedDate != null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppGap.regular(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Time', theme),
                              AppGap.small(),
                              InkWell(
                                onTap: state.isLoading ? null : _selectTime,
                                child: _buildDateTimeField(
                                  _formatTime(_selectedTime),
                                  Icons.access_time,
                                  theme,
                                  isSelected: _selectedTime != null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppGap.big(),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => _handleSubmit(widget.taskToEdit, ref),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colors.primary,
                          foregroundColor: theme.colors.primaryOpposite,
                          shape: RoundedRectangleBorder(
                            borderRadius: theme.radius.asBorderRadius().regular,
                          ),
                          elevation: 0,
                          disabledBackgroundColor: theme.colors.primary
                              .withAlpha(60),
                        ),
                        child: state.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colors.primaryOpposite,
                                  ),
                                ),
                              )
                            : AppText.paragraph1(
                                isEditMode ? 'Update task' : 'Add task',
                                color: theme.colors.primaryOpposite,
                              ),
                      ),
                    ),
                    // Extra bottom padding for keyboard
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // Loading overlay (optional, if you want full-screen loading)
              if (state.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, AppThemeData theme) {
    return AppText.paragraph1(text);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required AppThemeData theme,
    int maxLines = 1,
    int? maxLength,
    String? errorText,
    bool enabled = true,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: enabled,
      style: theme.typography.paragraph1.copyWith(
        color: enabled ? null : theme.colors.foreground.withAlpha(50),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: theme.colors.background,
        border: OutlineInputBorder(
          borderRadius: theme.radius.asBorderRadius().regular,
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : theme.colors.foreground,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: theme.radius.asBorderRadius().regular,
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : theme.colors.foreground,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: theme.radius.asBorderRadius().regular,
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : theme.colors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: theme.radius.asBorderRadius().regular,
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
        errorText: errorText,
        errorMaxLines: 2,
      ),
    );
  }

  Widget _buildDateTimeField(
    String text,
    IconData icon,
    AppThemeData theme, {
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: ShapeDecoration(
        color: theme.colors.background,
        shape: RoundedRectangleBorder(
          borderRadius: theme.radius.asBorderRadius().regular,
          side: BorderSide(
            color: isSelected ? theme.colors.primary : theme.colors.foreground,
            width: isSelected ? 2 : 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: theme.typography.paragraph1.copyWith(
                color: isSelected
                    ? theme.colors.foreground
                    : theme.colors.foreground.withAlpha(60),
              ),
            ),
          ),
          Icon(
            icon,
            color: isSelected ? theme.colors.primary : theme.colors.foreground,
            size: 20,
          ),
        ],
      ),
    );
  }
}
