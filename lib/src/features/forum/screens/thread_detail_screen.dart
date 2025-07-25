import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';

class ThreadDetailScreen extends ConsumerWidget {
  final String threadId;

  const ThreadDetailScreen({
    super.key,
    required this.threadId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thread Details'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text(
          'Thread Detail Screen - ID: $threadId',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}