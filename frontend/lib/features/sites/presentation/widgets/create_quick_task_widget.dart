import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/enums/task_priority.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/features/sites/data/models/quick_task_model.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_task/quick_task_bloc.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_task/quick_task_event.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_task/quick_task_state.dart';
import 'package:frontend/shared/widgets/cards/custom_app_card.dart';

class CreateQuickTaskWidget extends StatefulWidget {
  final String siteId;
  const CreateQuickTaskWidget({super.key, required this.siteId});

  @override
  State<CreateQuickTaskWidget> createState() => _CreateQuickTaskWidgetState();
}

class _CreateQuickTaskWidgetState extends State<CreateQuickTaskWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TaskPriority _priority = TaskPriority.low;

  late FocusNode _descriptionFocusNode;
  late FocusNode _priorityFocusNode;

  @override
  void initState() {
    super.initState();

    _descriptionFocusNode = FocusNode();
    _priorityFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    _descriptionFocusNode.dispose();
    _priorityFocusNode.dispose();
    super.dispose();
  }

  void createTask() {
    if (!_formKey.currentState!.validate()) return;
    final task = QuickTaskModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      priority: _priority,
    );

    context.read<QuickTaskBloc>().add(
      CreateQuickTaskRequested(siteId: widget.siteId, task: task),
    );
  }

  void cancelTask() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() => _priority = TaskPriority.low);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuickTaskBloc, QuickTaskState>(
      listener: (context, state) {
        if (state is QuickTaskError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.sm,
                ),
              ),
            );
        }

        if (state is QuickTaskCreated) {
          cancelTask();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text("Task created successfully!"),
              ),
            );
        }
      },
      builder: (context, state) {
        final isLoading = state is QuickTaskCreating;
        return CustomAppCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CREATE QUICK TASKS",
                  style: AppTypography.bodyPrimary.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Divider(color: AppColors.border, thickness: 1),
                _requiredLabel("Title"),
                const SizedBox(height: AppSpacing.xs),
                TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: AppTypography.bodyPrimary,
                  decoration: const InputDecoration(hintText: "Task title"),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) {
                      return 'Title is required';
                    }
                    if (value.length > 200) {
                      return 'Title cannot exceed 200 characters';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(
                      context,
                    ).requestFocus(_descriptionFocusNode);
                  },
                ),
                const SizedBox(height: AppSpacing.m),
                Text("Description", style: AppTypography.inputLabel),
                const SizedBox(height: AppSpacing.xs),
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  focusNode: _descriptionFocusNode,
                  textInputAction: TextInputAction.next,
                  style: AppTypography.bodyPrimary,
                  decoration: const InputDecoration(
                    hintText: "Describe what to be done.",
                  ),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.length > 2000) {
                      return 'Description cannot exceed 2000 characters';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priorityFocusNode);
                  },
                ),
                const SizedBox(height: AppSpacing.m),
                _requiredLabel("Priority"),
                const SizedBox(height: AppSpacing.xs),
                DropdownButtonFormField<TaskPriority>(
                  initialValue: _priority,
                  focusNode: _priorityFocusNode,
                  items: TaskPriority.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _priority = value);
                  },
                ),
                const SizedBox(height: AppSpacing.m),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 40,
                        child: FilledButton(
                          onPressed: isLoading ? null : () => createTask(),
                          child: isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.m),
                                    const Text("Creating Task..."),
                                  ],
                                )
                              : Text("Create Task"),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: isLoading ? null : () => cancelTask(),
                          child: Text("Cancel"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _requiredLabel(String text) {
    return Text.rich(
      TextSpan(
        text: text,
        style: AppTypography.inputLabel,
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
