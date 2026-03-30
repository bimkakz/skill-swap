import 'package:flutter/material.dart';
import '../theme.dart';
import 'dart:ui';

class VideoCallScreen extends StatefulWidget {
  final String receiverName;

  const VideoCallScreen({super.key, required this.receiverName});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated Remote Video (Background)
          if (!_isVideoOff)
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=1000',
                fit: BoxFit.cover,
              ),
            )
          else
            const Center(
              child: Icon(Icons.person, size: 120, color: Colors.white24),
            ),
            
          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock, color: Colors.greenAccent, size: 14),
                        const SizedBox(width: 6),
                        Text(widget.receiverName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32), // Balance the flex
                ],
              ),
            ),
          ),

          // Local Video (PiP)
          if (!_isVideoOff)
            Positioned(
              right: 20,
              top: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white38, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          // Call Controls (Bottom)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: _isMuted ? Icons.mic_off : Icons.mic,
                  color: _isMuted ? Colors.white : Colors.black45,
                  iconColor: _isMuted ? Colors.black : Colors.white,
                  onPressed: () => setState(() => _isMuted = !_isMuted),
                ),
                _buildControlButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  iconColor: Colors.white,
                  size: 64,
                  onPressed: () => Navigator.pop(context),
                ),
                _buildControlButton(
                  icon: _isVideoOff ? Icons.videocam_off : Icons.videocam,
                  color: _isVideoOff ? Colors.white : Colors.black45,
                  iconColor: _isVideoOff ? Colors.black : Colors.white,
                  onPressed: () => setState(() => _isVideoOff = !_isVideoOff),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required Color color, required Color iconColor, double size = 56, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: size * 0.5),
          ),
        ),
      ),
    );
  }
}
