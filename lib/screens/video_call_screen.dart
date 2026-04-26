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
  bool _isFrontCamera = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // 1. MAIN VIDEO BACKGROUND
            Positioned.fill(
              child: _isVideoOff 
                ? Container(
                    color: const Color(0xFF111827),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAvatar(80),
                          const SizedBox(height: 24),
                          Text(
                            widget.receiverName,
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Video Paused',
                            style: TextStyle(color: Colors.white54, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                : Image.network(
                    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=1200',
                    fit: BoxFit.cover,
                  ),
            ),

            // 2. GRADIENT OVERLAYS
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ),
                ),
              ),
            ),

            // 3. TOP BAR (INFO)
            Positioned(
              top: topPadding + 10,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  _buildBlurCircle(
                    icon: Icons.keyboard_arrow_down_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline_rounded, color: Colors.greenAccent, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          widget.receiverName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildBlurCircle(
                    icon: Icons.more_horiz_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // 4. LOCAL VIDEO (PiP)
            Positioned(
              right: 20,
              top: topPadding + 80,
              child: Container(
                width: 120,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 15, offset: Offset(0, 5))],
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1531123897727-8f129e16fd3c?q=80&w=200',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // 5. BOTTOM CONTROLS
            Positioned(
              bottom: bottomPadding + 30,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionBtn(
                            icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                            isActive: !_isMuted,
                            onTap: () => setState(() => _isMuted = !_isMuted),
                          ),
                          _buildActionBtn(
                            icon: _isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                            isActive: !_isVideoOff,
                            onTap: () => setState(() => _isVideoOff = !_isVideoOff),
                          ),
                          _buildActionBtn(
                            icon: Icons.flip_camera_ios_rounded,
                            onTap: () => setState(() => _isFrontCamera = !_isFrontCamera),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 15, spreadRadius: 2)],
                              ),
                              child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(double radius) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: SkillSwapColors.primary.withOpacity(0.5), width: 2),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: SkillSwapColors.primary.withOpacity(0.1),
        child: Text(
          widget.receiverName[0].toUpperCase(),
          style: TextStyle(fontSize: radius * 0.6, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBlurCircle({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildActionBtn({required IconData icon, bool isActive = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: isActive ? SkillSwapColors.primary : Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }
}



