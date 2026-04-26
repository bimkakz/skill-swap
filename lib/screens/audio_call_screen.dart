import 'package:flutter/material.dart';
import '../theme.dart';
import 'dart:ui';

class AudioCallScreen extends StatefulWidget {
  final String receiverName;

  const AudioCallScreen({super.key, required this.receiverName});

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  final Stopwatch _stopwatch = Stopwatch();
  late Stream<String> _timerStream;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _timerStream = Stream.periodic(const Duration(seconds: 1), (i) {
      final duration = _stopwatch.elapsed;
      return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient / Image
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              ),
            ),
          ),
          
          // Abstract background decor
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SkillSwapColors.primary.withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Top Info
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Colors.white54, size: 14),
                    SizedBox(width: 8),
                    Text(
                      'End-to-end encrypted',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                
                // Avatar Section
                Hero(
                  tag: 'call_avatar',
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: SkillSwapColors.primary.withOpacity(0.3), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: SkillSwapColors.primary.withOpacity(0.1),
                      child: Text(
                        widget.receiverName.isNotEmpty ? widget.receiverName[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Name & Status
                Text(
                  widget.receiverName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                StreamBuilder<String>(
                  stream: _timerStream,
                  initialData: '00:00',
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(
                        color: SkillSwapColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    );
                  },
                ),
                
                const Spacer(),
                
                // Controls
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCallAction(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        label: 'Mute',
                        isActive: _isMuted,
                        onTap: () => setState(() => _isMuted = !_isMuted),
                      ),
                      _buildCallAction(
                        icon: Icons.call_end,
                        label: 'End',
                        color: Colors.red,
                        isEnd: true,
                        onTap: () => Navigator.pop(context),
                      ),
                      _buildCallAction(
                        icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                        label: 'Speaker',
                        isActive: _isSpeakerOn,
                        onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
    bool isActive = false,
    bool isEnd = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: isEnd ? 72 : 64,
            height: isEnd ? 72 : 64,
            decoration: BoxDecoration(
              color: color ?? (isActive ? Colors.white : Colors.white10),
              shape: BoxShape.circle,
              boxShadow: isEnd ? [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ] : null,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.black : Colors.white,
              size: isEnd ? 32 : 28,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}
