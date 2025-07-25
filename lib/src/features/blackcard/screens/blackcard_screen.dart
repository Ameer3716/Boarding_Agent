import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';

class BlackcardScreen extends ConsumerStatefulWidget {
  const BlackcardScreen({super.key});

  @override
  ConsumerState<BlackcardScreen> createState() => _BlackcardScreenState();
}

class _BlackcardScreenState extends ConsumerState<BlackcardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blackcard'),
        backgroundColor: Colors.transparent,
      ),
      body: const Center(
        child: Text(
          'Blackcard Screen - Coming Soon',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}