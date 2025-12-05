part of 'add_task_screen.dart';

mixin AddTaskScreenHelpers<T extends StatefulWidget> on State<T> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool _isFormDirty = false;

  String? _titleError;

  void _onFormChanged() {
    if (!_isFormDirty) {
      setState(() => _isFormDirty = true);
    }
    // Clear title error when user starts typing
    if (_titleError != null && _titleController.text.trim().isNotEmpty) {
      setState(() => _titleError = null);
    }
  }

  bool _validateForm() {
    bool isValid = true;

    // Validate title
    if (_titleController.text.trim().isEmpty) {
      setState(() => _titleError = 'Task title is required');
      isValid = false;
    } else if (_titleController.text.trim().length > 100) {
      setState(() => _titleError = 'Title too long (max 100 characters)');
      isValid = false;
    }

    // Validate date
    if (_selectedDate == null) {
      _showErrorSnackBar('Please select a date');
      isValid = false;
    }

    // Validate time
    if (_selectedTime == null) {
      _showErrorSnackBar('Please select a time');
      isValid = false;
    }

    return isValid;
  }

  Future<void> _handleSubmit(Task? taskToEdit, WidgetRef ref) async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Validate form
    if (!_validateForm()) return;

    final notifier = ref.read(taskFormNotifierProvider.notifier);

    // Combine date and time
    final taskDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (taskToEdit == null) {
      // Create mode
      await notifier.createTask(
        description: _descriptionController.text.trim(),
        title: _titleController.text.trim(),
        taskDate: _selectedDate!,
        taskTime: taskDateTime,
      );
    } else {
      // Update mode
      await notifier.updateTask(
        id: taskToEdit.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isCompleted: taskToEdit.isCompleted,
        taskDate: _selectedDate!,
        taskTime: taskDateTime,
      );
    }
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(2060),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
        _isFormDirty = true;
      });
    }
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
        _isFormDirty = true;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      UiHelper.showSnackBar(message, context: context, bgColor: Colors.red);
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      UiHelper.showSnackBar(message, context: context, bgColor: Colors.green);
    }
  }

  Future<bool> _onWillPop() async {
    // Only show warning if form has unsaved changes
    if (!_isFormDirty) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to leave?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
