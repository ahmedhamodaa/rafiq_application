import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatMessage {
  final int? id;
  final String userId;
  final String text;
  final DateTime createdAt;
  final int sessionId;

  ChatMessage({
    this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
    required this.sessionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'sessionId': sessionId,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      userId: map['userId'],
      text: map['text'],
      createdAt: DateTime.parse(map['createdAt']),
      sessionId: map['sessionId'],
    );
  }
}

class Session {
  final int? id;
  final String name;
  final DateTime createdAt;

  Session({
    this.id,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'chat_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sessions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            createdAt TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE messages(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            text TEXT,
            createdAt TEXT,
            sessionId INTEGER,
            FOREIGN KEY(sessionId) REFERENCES sessions(id)
          )
        ''');
      },
    );
  }

  Future<int> insertSession(Session session) async {
    final db = await database;
    return await db.insert('sessions', session.toMap());
  }

  Future<List<Session>> getSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sessions');
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  Future<int> updateSession(Session session) async {
    final db = await database;
    return await db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<int> deleteSession(int sessionId) async {
    final db = await database;
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<int> insertMessage(ChatMessage message) async {
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<ChatMessage>> getMessages(int sessionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'sessionId = ?',
      whereArgs: [sessionId],
    );
    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }
}

class RafiqChatbotScreen extends StatefulWidget {
  const RafiqChatbotScreen({super.key});

  @override
  RafiqChatbotScreenState createState() => RafiqChatbotScreenState();
}

class RafiqChatbotScreenState extends State<RafiqChatbotScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  ChatUser? _currentUser;
  int? _currentSessionId;
  Gemini? gemini;

  final ChatUser _chatGPTUser = ChatUser(
    id: "Dono-r",
    firstName: "Dono-r",
  );

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _setupCurrentUser();
    _loadLastSession();
  }

  void _initializeGemini() {
    Gemini.init(
      apiKey: 'AIzaSyDKfaujzd3G1MR0S8rnMTBkZaf5taaHiDs',
      enableDebugging: true,
    );
    gemini = Gemini.instance;
  }

  void _setupCurrentUser() {
    _currentUser = ChatUser(
      id: "local_user",
      firstName: "You",
    );
  }

  Future<void> _loadLastSession() async {
    final sessions = await _dbHelper.getSessions();
    if (sessions.isNotEmpty) {
      _currentSessionId = sessions.last.id;
      await _loadMessages(_currentSessionId!);
    } else {
      await _createNewSession();
    }
  }

  Future<void> _createNewSession() async {
    final newSession = Session(
      name: "Session ${DateFormat('MMM d, y').format(DateTime.now())}",
      createdAt: DateTime.now(),
    );
    _currentSessionId = await _dbHelper.insertSession(newSession);
    if (mounted) {
      setState(() {
        _messages.clear();
      });
    }
  }

  Future<void> _loadMessages(int sessionId) async {
    final messages = await _dbHelper.getMessages(sessionId);
    if (mounted) {
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
      });
      _scrollToBottom();
    }
  }

  Future<void> _saveMessage(String text, bool isUser) async {
    if (_currentSessionId == null) return;

    final message = ChatMessage(
      userId: isUser ? _currentUser!.id : _chatGPTUser.id,
      text: text,
      createdAt: DateTime.now(),
      sessionId: _currentSessionId!,
    );

    await _dbHelper.insertMessage(message);
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || _currentUser == null) return;

    final newMessage = ChatMessage(
      userId: _currentUser!.id,
      text: text,
      createdAt: DateTime.now(),
      sessionId: _currentSessionId!,
    );

    if (mounted) {
      setState(() {
        _messages.add(newMessage);
        _messageController.clear();
      });
    }

    await _saveMessage(text, true);
    _scrollToBottom();

    try {
      final response = await gemini?.chat([
        Content(parts: [Part.text(text)], role: 'user'),
      ]);

      final botResponse = response?.output ?? "No response from Gemini";

      final botMessage = ChatMessage(
        userId: _chatGPTUser.id,
        text: botResponse,
        createdAt: DateTime.now(),
        sessionId: _currentSessionId!,
      );

      if (mounted) {
        setState(() => _messages.add(botMessage));
      }
      await _saveMessage(botResponse, false);
      _scrollToBottom();
    } catch (e) {
      debugPrint("Error communicating with Gemini: $e");
      final errorMessage = ChatMessage(
        userId: _chatGPTUser.id,
        text: "Failed to get a response. Please try again later.",
        createdAt: DateTime.now(),
        sessionId: _currentSessionId!,
      );
      setState(() => _messages.add(errorMessage));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _renameSession(Session session, BuildContext context) async {
    final newNameController = TextEditingController(text: session.name);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Rename Session"),
              content: TextField(
                controller: newNameController,
                decoration: const InputDecoration(
                  labelText: "New Session Name",
                ),
                onChanged: (value) {
                  setState(() {
                    // Rebuild the dialog with the new value
                    session = Session(
                      id: session.id,
                      name: value,
                      createdAt: session.createdAt,
                    );
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    final newName = newNameController.text.trim();
                    if (newName.isNotEmpty) {
                      final updatedSession = Session(
                        id: session.id,
                        name: newName,
                        createdAt: session.createdAt,
                      );
                      await _dbHelper.updateSession(updatedSession);
                      if (mounted) {
                        setState(() {});
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteSession(int sessionId) async {
    await _dbHelper.deleteSession(sessionId);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rafiq Chat Assistant"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              final sessions = await _dbHelper.getSessions();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Chat Sessions"),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: sessions.length,
                        itemBuilder: (BuildContext context, int index) {
                          final session = sessions[index];
                          return ListTile(
                            title: Text(session.name),
                            subtitle: Text(DateFormat('MMM d, y')
                                .format(session.createdAt)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _renameSession(session, context),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteSession(session.id!),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() => _currentSessionId = session.id);
                              Navigator.pop(context);
                              _loadMessages(session.id!);
                            },
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await _createNewSession();
                          Navigator.pop(context);
                        },
                        child: const Text("New Session"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 200,
                  height: 100,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = _messages[index];
                    final isUser = message.userId == _currentUser?.id;
                    return _buildMessageItem(message, isUser);
                  },
                ),
              ),
              _buildMessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message, bool isUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              radius: 20,
              child: Icon(Icons.android),
            ),
          Expanded(
            child: Padding(
              padding: isUser
                  ? const EdgeInsets.only(right: 4)
                  : const EdgeInsets.only(left: 4),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message.text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('hh:mm a').format(message.createdAt),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          if (isUser)
            const CircleAvatar(
              radius: 20,
              child: Icon(Icons.person),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Type your message...",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }
}
