import 'package:flutter/material.dart';

void showShareBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ShareBottomSheet(),
  );
}

class _ShareBottomSheet extends StatelessWidget {
  const _ShareBottomSheet();

  final List<Map<String, dynamic>> _platforms = const [
    {'label': 'Facebook', 'color': Color(0xFF1877F2), 'icon': Icons.facebook},
    {'label': 'Google', 'color': Color(0xFFDB4437), 'icon': Icons.g_mobiledata},
    {
      'label': 'Kakao Talk',
      'color': Color(0xFFFFE300),
      'icon': Icons.chat_bubble,
    },
    {'label': 'Whatsapp', 'color': Color(0xFF25D366), 'icon': Icons.call},
    {
      'label': 'Twitter',
      'color': Color(0xFF1DA1F2),
      'icon': Icons.airplanemode_on,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main sheet
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Title
              Text(
                'Share on',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              // Icons row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: _platforms.map((p) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _ShareIcon(
                        label: p['label'],
                        color: p['color'],
                        icon: p['icon'],
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: handle share to ${p['label']}
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Cancel button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[600],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

class _ShareIcon extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ShareIcon({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
        ],
      ),
    );
  }
}

