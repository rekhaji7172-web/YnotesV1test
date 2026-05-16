import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/note.dart';

class StorageService {
  static const String _tasksKey = 'ynotes_tasks';
  static const String _notesKey = 'ynotes_notes';

  // Tasks
  static Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(_tasksKey);
    if (tasksJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(tasksJson);
    return decoded.map((item) => Task.fromJson(item)).toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_tasksKey, encoded);
  }

  // Notes
  static Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString(_notesKey);
    if (notesJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(notesJson);
    return decoded.map((item) => Note.fromJson(item)).toList();
  }

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(notes.map((n) => n.toJson()).toList());
    await prefs.setString(_notesKey, encoded);
  }
}
