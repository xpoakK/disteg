import 'package:flutter/material.dart';

class SidebarUsers extends StatefulWidget {
  final Function(String) onSelect;
  final String? selectedUser;

  const SidebarUsers({
    super.key,
    required this.onSelect,
    required this.selectedUser,
  });

  @override
  State<SidebarUsers> createState() => _SidebarUsersState();
}

class _SidebarUsersState extends State<SidebarUsers> {
  double width = 180;
  final double maxWidth = 180;
  final double minWidth = 60;

  final List<Map<String, dynamic>> users = [
    {"name": "Алексей", "online": true},
    {"name": "Марина", "online": false},
    {"name": "Иван", "online": true},
    {"name": "Светлана", "online": true},
    {"name": "Дмитрий", "online": false},
    {"name": "Ольга", "online": true},
    {"name": "Никита", "online": true},
    {"name": "Екатерина", "online": false},
    {"name": "Сергей", "online": true},
    {"name": "Анна", "online": true},
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users
        .where((u) => u["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          width += details.delta.dx;
          if (width > maxWidth) width = maxWidth;
          if (width < minWidth) width = minWidth;
        });
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          width = width > (maxWidth + minWidth) / 2 ? maxWidth : minWidth;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150), // быстрее
        width: width,
        curve: Curves.easeOut,
        color: const Color(0xFF2B2B2B),
        child: Column(
          children: [
            const SizedBox(height: 8),
            if (width > minWidth + 20)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Поиск",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: const Color(0xFF3A3A3A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, i) {
                  final user = filteredUsers[i];
                  final selected = user["name"] == widget.selectedUser;
                  return InkWell(
                    onTap: () => widget.onSelect(user["name"]),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: selected
                          ? BoxDecoration(
                        color: const Color(0xFF3A3A3A),
                        borderRadius: BorderRadius.circular(8),
                      )
                          : null,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey.shade700,
                                child: Text(
                                  user["name"][0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: user["online"] ? Colors.green : Colors.grey,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF2B2B2B), width: 1.5),
                                  ),
                                ),
                              )
                            ],
                          ),
                          // Контент теперь не переполняется
                          if (width > minWidth + 20) const SizedBox(width: 12),
                          if (width > minWidth + 20)
                            Flexible(
                              child: Text(
                                user["name"],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: selected ? Colors.white : Colors.grey[300],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
