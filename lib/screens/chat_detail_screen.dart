import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import 'video_call_screen.dart';
import 'audio_call_screen.dart';

class ChatDetailScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final bool isExchangeMode;

  const ChatDetailScreen({super.key, required this.receiverId, required this.receiverName, this.isExchangeMode = false});

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

  Future<void> _completeExchange() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final batch = FirebaseFirestore.instance.batch();
      final myRef = FirebaseFirestore.instance.collection('users').doc(_currentUserId);
      final partnerRef = FirebaseFirestore.instance.collection('users').doc(widget.receiverId);
      
      batch.set(myRef, {
        'points': FieldValue.increment(50),
        'exchanges': FieldValue.increment(1),
      }, SetOptions(merge: true));
      
      batch.set(partnerRef, {
        'points': FieldValue.increment(50),
        'exchanges': FieldValue.increment(1),
      }, SetOptions(merge: true));

      final myHistoryRef = myRef.collection('history').doc();
      final partnerHistoryRef = partnerRef.collection('history').doc();

      batch.set(myHistoryRef, {
        'type': 'exchange',
        'partnerId': widget.receiverId,
        'partnerName': widget.receiverName,
        'timestamp': FieldValue.serverTimestamp(),
        'pointsAwarded': 50,
      });

      batch.set(partnerHistoryRef, {
        'type': 'exchange',
        'partnerId': _currentUserId,
        'partnerName': FirebaseAuth.instance.currentUser?.displayName ?? 'User',
        'timestamp': FieldValue.serverTimestamp(),
        'pointsAwarded': 50,
      });
      
      await batch.commit();
      _sendMessage(type: 'system', text: '✅ Exchange completed! +50 Points awarded to both users.');

      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        _showRatingDialog(); // Show rating dialog after exchange
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to complete exchange.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _completeLesson() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final batch = FirebaseFirestore.instance.batch();
      final myRef = FirebaseFirestore.instance.collection('users').doc(_currentUserId);
      final partnerRef = FirebaseFirestore.instance.collection('users').doc(widget.receiverId);
      
      // Increment lessons count
      batch.set(myRef, {'lessons': FieldValue.increment(1)}, SetOptions(merge: true));
      batch.set(partnerRef, {'lessons': FieldValue.increment(1)}, SetOptions(merge: true));
      
      final myHistoryRef = myRef.collection('history').doc();
      final partnerHistoryRef = partnerRef.collection('history').doc();

      batch.set(myHistoryRef, {
        'type': 'lesson',
        'partnerId': widget.receiverId,
        'partnerName': widget.receiverName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      batch.set(partnerHistoryRef, {
        'type': 'lesson',
        'partnerId': _currentUserId,
        'partnerName': FirebaseAuth.instance.currentUser?.displayName ?? 'User',
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
      _sendMessage(type: 'system', text: '🎓 Lesson completed! Statistics updated.');

      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        _showRatingDialog(); // Show rating dialog after lesson
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to complete lesson.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showRatingDialog() {
    double selectedRating = 5.0;
    final TextEditingController reviewController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Rate ${widget.receiverName}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('How was your experience?'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < selectedRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () => setState(() => selectedRating = index + 1.0),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reviewController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write a short review...',
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Skip')),
            ElevatedButton(
              onPressed: () async {
                await _updateUserRating(widget.receiverId, selectedRating, reviewController.text.trim());
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserRating(String userId, double newRating, String reviewText) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final double currentRating = (data['rating'] ?? 0.0).toDouble();
      final int currentCount = data['ratingCount'] ?? 0;

      final double updatedRating = ((currentRating * currentCount) + newRating) / (currentCount + 1);
      
      transaction.update(userRef, {
        'rating': updatedRating,
        'ratingCount': currentCount + 1,
      });

      // Also add the review to a subcollection
      if (reviewText.isNotEmpty) {
        final reviewRef = userRef.collection('reviews').doc();
        transaction.set(reviewRef, {
          'rating': newRating,
          'text': reviewText,
          'authorId': _currentUserId,
          'authorName': FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: theme.dividerColor, height: 1),
        ),
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
          if (widget.isExchangeMode)
            TextButton.icon(
              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              label: const Text('Complete', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onPressed: _completeExchange,
            ),
          if (!widget.isExchangeMode)
            IconButton(
              icon: const Icon(Icons.phone_outlined), 
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AudioCallScreen(receiverName: widget.receiverName)));
              }
            ),
          if (!widget.isExchangeMode)
            IconButton(
                icon: const Icon(Icons.videocam_outlined), 
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => VideoCallScreen(receiverName: widget.receiverName)));
                }),
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
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: SkillSwapColors.primary.withOpacity(0.3)),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
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
                                    ElevatedButton(onPressed: () {
                                      _sendMessage(type: 'text', text: 'I accepted the lesson proposal!');
                                    }, child: const Text('Accept')),
                                  ],
                                ),
                              if (isMe || true) // Show "Complete" option for demo/testing
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextButton.icon(
                                    onPressed: _completeLesson,
                                    icon: const Icon(Icons.check_circle_outline),
                                    label: const Text('Complete Lesson'),
                                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                                  ),
                                ),
                              if (isMe)
                                const Text('Waiting for response...', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }

                    if (msgType == 'system') {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Text(msg['text'] ?? '', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
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
                              color: isMe ? (isDark ? SkillSwapColors.raspberry : SkillSwapColors.primary) : theme.cardColor,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: Radius.circular(isMe ? 20 : 0),
                                bottomRight: Radius.circular(isMe ? 0 : 20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2))
                              ],
                            ),
                            child: Text(msg['text'] ?? '',
                                style: TextStyle(
                                    color: isMe
                                        ? Colors.white
                                        : theme.textTheme.bodyLarge?.color)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(timeString,
                                style: TextStyle(
                                    fontSize: 10, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6))),
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
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _proposeSchedule,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey.shade100, shape: BoxShape.circle),
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
                        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
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
                      decoration: BoxDecoration(
                          color: isDark ? SkillSwapColors.raspberry : SkillSwapColors.primary,
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
