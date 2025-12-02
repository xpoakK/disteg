import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';
import '../utils/message_cache.dart';
import 'dart:math';

class ChatWindow extends StatefulWidget {
  final String? username; // текущий выбранный пользователь (партнёр, от кого приходят)
  final bool isMobile;

  const ChatWindow({super.key, required this.username, this.isMobile = false});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> _messages = [];
  String selfName = "You"; // локальный пользователь

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final loaded = await MessageCache.loadMessages();
    setState(() => _messages = loaded);
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final msg = MessageModel(
      id: UniqueKey().toString(),
      author: selfName,
      text: text.trim(),
      createdAt: DateTime.now(),
    );
    setState(() {
      _messages.add(msg);
    });
    await MessageCache.saveMessages(_messages);
    _controller.clear();
    _scrollToEnd();

    // здесь можно эмулировать ответ от выбранного пользоватля (в тестовом режиме)
    if (widget.username != null) {
      Future.delayed(const Duration(milliseconds: 700), () async {
        final reply = MessageModel(
          id: UniqueKey().toString(),
          author: widget.username!,
          text: _autoReply(text),
          createdAt: DateTime.now(),
        );
        setState(() => _messages.add(reply));
        await MessageCache.saveMessages(_messages);
        _scrollToEnd();
      });
    }
  }

  String _autoReply(String inText) {
    final samples = [
      "Понял!",
      "Хорошо, сделал.",
      "Можем обсудить позже?",
      "Отлично!",
      "Спасибо!",
    ];
    return samples[Random().nextInt(samples.length)];
  }

  Widget _buildBubble(MessageModel m, bool mine, bool showAvatar) {
    final theme = Theme.of(context);
    final time = DateFormat.Hm().format(m.createdAt);
    final bg = mine ? theme.primaryColor : theme.cardColor;
    final txtColor = mine ? Colors.white : theme.textTheme.bodyLarge!.color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!mine)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(radius: 16, child: Text(m.author[0])),
          ),
        Flexible(
          child: Column(
            crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (showAvatar && !mine)
                Text(m.author, style: theme.textTheme.bodySmall),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: mine ? theme.primaryColor : theme.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(mine ? 12 : 3),
                    bottomRight: Radius.circular(mine ? 3 : 12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(m.text, style: TextStyle(color: txtColor)),
                    const SizedBox(height: 6),
                    Text(time, style: theme.textTheme.bodySmall!.copyWith(fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (mine)
          const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // header
          Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                if (widget.isMobile)
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                CircleAvatar(child: Text(widget.username != null ? widget.username![0] : 'A')),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.username ?? "Выберите чат", style: theme.textTheme.titleMedium),
                      Text(widget.username != null ? "Online" : "Нет контакта", style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                // actions placeholder
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                const SizedBox(width: 8),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),

          // message area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final m = _messages[idx];
                final mine = m.author == selfName;
                final prevAuthor = idx > 0 ? _messages[idx - 1].author : null;
                final showAvatar = prevAuthor != m.author;
                return _buildBubble(m, mine, showAvatar);
              },
            ),
          ),

          // input
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: theme.cardColor,
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Сообщение',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      onSubmitted: (t) => _sendMessage(t),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    onPressed: () => _sendMessage(_controller.text),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
