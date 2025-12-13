import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NotesScreen extends StatefulWidget {
  final int userId;
  NotesScreen({required this.userId});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List notes = [];
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void loadNotes() async {
    final data = await getNotes(widget.userId);
    setState(() => notes = data);
  }

  void addNote() async {
    await createNote(widget.userId, titleController.text, contentController.text);
    titleController.clear();
    contentController.clear();
    loadNotes();
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Мои заметки'),
      ),
      body: Column(
        children: [
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Text(
                      'Пока нет заметок',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: notes.length,
                    itemBuilder: (_, i) => Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(notes[i]['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(notes[i]['content']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await deleteNote(notes[i]['id'], widget.userId);
                            loadNotes(); // Обновляем список
                          },
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            padding: EdgeInsets.all(24),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Заголовок',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    hintText: 'Содержание',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: addNote,
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text('Добавить заметку', style: TextStyle(fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
