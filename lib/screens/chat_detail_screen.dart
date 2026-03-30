import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import 'video_call_screen.dart';

class ChatDetailScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatDetailScreen({super.key, required this.receiverId, required this.receiverName});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  String get _chatId {
    List<String> ids = [_currentUserId, widget.receiverId];
    ids.sort();
    return ids.join('_');
  }

  void _sendMessage({String type = 'text', String text = '', DateTime? scheduledDate}) async {
    final messageText = text.isEmpty ? _controller.text.trim() : text.trim();
    if (messageText.isEmpty && type == 'text') return;
    if (type == 'text') _controller.clear();
    
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatId)
        .collection('messages')
        .add({
      'senderId': _currentUserId,
      'receiverId': widget.receiverId,
      'text': messageText,
      'type': type,
      'scheduledDate': scheduledDate != null ? Timestamp.fromDate(scheduledDate) : null,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _proposeSchedule() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 15, minute: 0),
      );
      if (pickedTime != null) {
        final DateTime scheduled = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        _sendMessage(type: 'schedule', text: 'Proposed a lesson', scheduledDate: scheduled);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: SkillSwapColors.primary.withOpacity(0.2),
              radius: 18,
              child: Text(widget.receiverName.isNotEmpty ? widget.receiverName[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 14, color: SkillSwapColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiverName,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('Online',
                    style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.videocam_outlined), 
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => VideoCallScreen(receiverName: widget.receiverName)));
              }),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(_chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final messages = snapshot.data!.docs;
                
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final isMe = msg['senderId'] == _currentUserId;
                    final msgType = msg['type'] ?? 'text';
                    final Timestamp? ts = msg['timestamp'] as Timestamp?;
                    final timeString = ts != null ? DateFormat('hh:mm a').format(ts.toDate()) : 'Now';

                    if (msgType == 'schedule') {
                      final Timestamp? schedTs = msg['scheduledDate'] as Timestamp?;
                      final scheduleText = schedTs != null ? DateFormat('MMM d, yyyy - hh:mm a').format(schedTs.toDate()) : 'Unknown Date';
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: SkillSwapColors.primary.withOpacity(0.3)),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.event, color: SkillSwapColors.primary, size: 32),
                              const SizedBox(height: 8),
                              Text(isMe ? 'You proposed a lesson' : '${widget.receiverName} proposed a lesson', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(scheduleText, style: const TextStyle(color: SkillSwapColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 12),
                              if (!isMe)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OutlinedButton(onPressed: () {}, child: const Text('Decline')),
                                    const SizedBox(width: 8),
                                    ElevatedButton(onPressed: () {}, child: const Text('Accept')),
                                  ],
                                ),
                              if (isMe)
                                const Text('Waiting for response...', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isMe ? SkillSwapColors.primary : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: Radius.circular(isMe ? 20 : 0),
                                bottomRight: Radius.circular(isMe ? 0 : 20),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2))
                              ],
                            ),
                            child: Text(msg['text'] ?? '',
                                style: TextStyle(
                                    color: isMe
                                        ? Colors.white
                                        : SkillSwapColors.textHeader)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(timeString,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _proposeSchedule,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                      child: const Icon(Icons.calendar_month, color: SkillSwapColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                          color: SkillSwapColors.primary,
                          shape: BoxShape.circle),
                      child:
                          const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
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
