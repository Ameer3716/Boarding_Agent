import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class HomeDashboard extends ConsumerStatefulWidget {
  const HomeDashboard({super.key});

  @override
  ConsumerState<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends ConsumerState<HomeDashboard>
    with SingleTickerProviderStateMixin {
  final TextEditingController _questionController = TextEditingController();
  final FocusNode _questionFocusNode = FocusNode();
  bool _isQuestionFocused = false;
  
  AnimationController? _pointsAnimationController;
  Animation<int>? _pointsAnimation;

  @override
  void initState() {
    super.initState();
    print("🏠 HomeDashboard initState started");
    
    _questionFocusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isQuestionFocused = _questionFocusNode.hasFocus;
        });
      }
    });

    // Simplified animation
    _pointsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Further reduced
      vsync: this,
    );

    _pointsAnimation = IntTween(begin: 0, end: 150).animate(
      CurvedAnimation(
        parent: _pointsAnimationController!,
        curve: Curves.easeOut,
      ),
    );

    // Start animation after a delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pointsAnimationController?.forward();
      }
    });

    print("✅ HomeDashboard initialized");
  }

  @override
  void dispose() {
    _questionController.dispose();
    _questionFocusNode.dispose();
    _pointsAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("🏗️ Building HomeDashboard");
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      data: (user) => _buildDashboard(user),
      loading: () => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(currentUserProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(user) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(), // Better performance
      child: Column(
        children: [
          // Simplified header
          _buildHeader(user),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildAskBoardroomSection(),
                const SizedBox(height: 24),
                _buildStatsRow(user),
                const SizedBox(height: 24),
                _buildRecentActivitySection(),
                const SizedBox(height: 24),
                _buildTopContributorsSection(),
                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0B),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good ${_getGreeting()}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  user?.displayName ?? 'Agent',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
          // Simplified avatar
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(user) {
    return Row(
      children: [
        Expanded(
          child: _buildStatsCard(
            'Your Points',
            user?.totalPoints ?? 0,
            Icons.stars,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatsCard(
            'Your Rank',
            user?.rank ?? 0,
            Icons.leaderboard,
            AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAskBoardroomSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.forum,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Ask the Boardroom',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Simple input field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isQuestionFocused ? AppColors.primary : AppColors.border,
                  width: _isQuestionFocused ? 2 : 1,
                ),
                color: AppColors.inputBackground,
              ),
              child: TextField(
                controller: _questionController,
                focusNode: _questionFocusNode,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'What would you like to ask the community?',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) {
                  if (mounted) setState(() {});
                },
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Simple counter and button
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_questionController.text.length}/280',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _questionController.text.length > 280
                          ? AppColors.error
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _questionController.text.isNotEmpty
                      ? () {
                          print("📝 Posting question: ${_questionController.text}");
                        }
                      : null,
                  child: const Text('Ask'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Simple tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                'Lead Generation',
                'Brand Building',
                'Increasing Fees',
                'Conversions',
              ].map(_buildTagChip).toList(),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTagChip(String tag) {
    return InkWell(
      onTap: () {
        print("🏷️ Tag tapped: $tag");
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Text(
          tag,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, int value, IconData icon, Color color) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            // Animate points only
            if (title == 'Your Points')
              _pointsAnimation != null ? AnimatedBuilder(
                animation: _pointsAnimation!,
                builder: (context, child) {
                  return Text(
                    _pointsAnimation!.value.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ) : Text(
                value.toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: AppColors.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Activity items
            ..._buildActivityItems(),
            
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  print("📋 View all activity tapped");
                },
                child: const Text('View All Activity'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActivityItems() {
    const activities = [
      {
        'type': 'question',
        'title': 'How to improve lead conversion rates?',
        'time': '2 hours ago',
        'engagement': '12 replies',
      },
      {
        'type': 'answer',
        'title': 'Best practices for property photography',
        'time': '5 hours ago',
        'engagement': '8 likes',
      },
      {
        'type': 'comment',
        'title': 'Market trends in London area',
        'time': '1 day ago',
        'engagement': '3 comments',
      },
    ];

    return activities.map((activity) => _buildActivityItem(activity)).toList();
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    IconData icon;
    Color iconColor;
    
    switch (activity['type'] as String) {
      case 'question':
        icon = Icons.help_outline;
        iconColor = AppColors.primary;
        break;
      case 'answer':
        icon = Icons.lightbulb_outline;
        iconColor = AppColors.success;
        break;
      case 'comment':
        icon = Icons.comment_outlined;
        iconColor = AppColors.secondary;
        break;
      default:
        icon = Icons.circle;
        iconColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      activity['time'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      activity['engagement'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopContributorsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: AppColors.gold,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Top Contributors',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Contributors
            ..._buildTopContributors(),
            
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  print("🏆 View leaderboard tapped");
                },
                child: const Text('View Leaderboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTopContributors() {
    const contributors = [
      {
        'name': 'Sarah Johnson',
        'agency': 'Premium Properties',
        'points': '2,450',
        'rank': 1,
      },
      {
        'name': 'Mike Thompson',
        'agency': 'City Estates',
        'points': '2,120',
        'rank': 2,
      },
      {
        'name': 'Emma Wilson',
        'agency': 'Urban Homes',
        'points': '1,890',
        'rank': 3,
      },
    ];

    return contributors.map((contributor) => _buildContributorItem(contributor)).toList();
  }

  Widget _buildContributorItem(Map<String, dynamic> contributor) {
    Color rankColor;
    IconData rankIcon;
    
    switch (contributor['rank'] as int) {
      case 1:
        rankColor = AppColors.gold;
        rankIcon = Icons.looks_one;
        break;
      case 2:
        rankColor = AppColors.textSecondary;
        rankIcon = Icons.looks_two;
        break;
      case 3:
        rankColor = const Color(0xFFCD7F32);
        rankIcon = Icons.looks_3;
        break;
      default:
        rankColor = AppColors.textSecondary;
        rankIcon = Icons.circle;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              rankIcon,
              color: rankColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contributor['name'] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  contributor['agency'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${contributor['points']} pts',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}