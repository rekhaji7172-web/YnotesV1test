import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _selectedPriority = 'medium';
  DateTime? _selectedReminder;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await StorageService.getTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _addTask() async {
    if (_taskController.text.isEmpty) return;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'local_user',
      title: _taskController.text,
      completed: false,
      priority: _selectedPriority,
      createdAt: DateTime.now(),
      reminderAt: _selectedReminder,
    );

    final updatedTasks = [newTask, ..._tasks];
    await StorageService.saveTasks(updatedTasks);
    
    _taskController.clear();
    setState(() {
      _tasks = updatedTasks;
      _selectedPriority = 'medium';
      _selectedReminder = null;
    });
  }

  Future<void> _toggleTask(Task task) async {
    final updatedTasks = _tasks.map((t) {
      if (t.id == task.id) {
        return t.copyWith(completed: !t.completed);
      }
      return t;
    }).toList();
    
    await StorageService.saveTasks(updatedTasks);
    setState(() => _tasks = updatedTasks);
  }

  Future<void> _deleteTask(String id) async {
    final updatedTasks = _tasks.where((t) => t.id != id).toList();
    await StorageService.saveTasks(updatedTasks);
    setState(() => _tasks = updatedTasks);
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              TextField(
                controller: _taskController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ...['low', 'medium', 'high'].map((p) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(p.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      selected: _selectedPriority == p,
                      onSelected: (val) => setSheetState(() => _selectedPriority = p),
                      selectedColor: Colors.indigo.shade100,
                      labelStyle: TextStyle(color: _selectedPriority == p ? Colors.indigo : Colors.grey),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: Icon(LucideIcons.bell, size: 20, color: _selectedReminder != null ? Colors.indigo : Colors.grey),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setSheetState(() => _selectedReminder = DateTime(date.year, date.month, date.day, time.hour, time.minute));
                        }
                      }
                    },
                  ),
                  if (_selectedReminder != null)
                    Text(
                      'Remind at ${_selectedReminder!.hour}:${_selectedReminder!.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _addTask();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('YTasks', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1, fontSize: 24)),
            Text('STAY FOCUSED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 2)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.checkSquare, size: 64, color: Colors.grey.shade200),
                      const SizedBox(height: 16),
                      const Text('No tasks today', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    Color priorityColor = Colors.green;
                    if (task.priority == 'high') priorityColor = Colors.red;
                    if (task.priority == 'medium') priorityColor = Colors.amber;

                    return Dismissible(
                      key: Key(task.id),
                      onDismissed: (dir) => _deleteTask(task.id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(24)),
                        child: const Icon(LucideIcons.trash2, color: Colors.red),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: task.completed ? Colors.grey.shade50 : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: task.completed ? Colors.transparent : Colors.grey.shade100),
                          boxShadow: task.completed ? [] : [
                            BoxShadow(color: Colors.indigo.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: IconButton(
                            icon: Icon(
                              task.completed ? LucideIcons.checkCircle : LucideIcons.circle,
                              color: task.completed ? Colors.indigo : Colors.grey.shade300,
                              size: 28,
                            ),
                            onPressed: () => _toggleTask(task),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: task.completed ? Colors.grey : Colors.blueGrey.shade800,
                              decoration: task.completed ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(color: priorityColor, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  task.priority.toUpperCase(),
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade400, letterSpacing: 1),
                                ),
                                if (task.reminderAt != null) ...[
                                  const SizedBox(width: 12),
                                  const Icon(LucideIcons.bell, size: 10, color: Colors.indigo),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${task.reminderAt!.hour}:${task.reminderAt!.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.indigo),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _showAddTaskSheet,
        backgroundColor: Colors.blueGrey.shade900,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: const Icon(LucideIcons.plus, size: 32),
      ),
    );
  }
}
