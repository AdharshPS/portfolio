import 'package:flutter/material.dart';

class AboutDesktopScreen extends StatelessWidget {
  const AboutDesktopScreen({super.key, required this.aboutKey});
  final GlobalKey aboutKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      child: SingleChildScrollView(
        key: aboutKey,
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Card(
              color: Colors.blueGrey.shade900,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.blueGrey.shade700,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Me',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.tealAccent.shade100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Hi! I'm a passionate Flutter developer dedicated to crafting beautiful, performant apps that people love to use. "
                      "With a background in user-centric design and efficient coding, "
                      "I bring ideas to life with clean, maintainable code and a focus on seamless user experiences. "
                      "Collaboration, innovation, and continuous learning drive me every day. "
                      "Let’s build something amazing together!",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        height: 1.5,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Divider(color: Colors.tealAccent.shade100.withOpacity(0.5)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.tealAccent.shade100),
                        const SizedBox(width: 10),
                        Text(
                          'email@example.com',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.tealAccent.shade100),
                        const SizedBox(width: 10),
                        Text(
                          '+123 456 7890',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add action like downloading resume or navigating
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download My Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent.shade400,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
