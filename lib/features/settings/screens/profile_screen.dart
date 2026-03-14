import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/theme_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock highlight data
  final List<Map<String, String>> _highlights = [
    {'image': 'https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=150', 'label': '✨✨'},
    {'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=150', 'label': 'soul'},
    {'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150', 'label': 'amoOoOr'},
    {'image': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=150', 'label': '(✏️)'},
  ];

  // Mock grid images
  final List<String> _gridImages = [
    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400',
    'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400',
    'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=400',
    'https://images.unsplash.com/photo-1488590528505-98d2b5aba04b?w=400',
    'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400',
    'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=400',
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400',
    'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400',
    'https://images.unsplash.com/photo-1550439062-609e1531270e?w=400',
    'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=400',
    'https://images.unsplash.com/photo-1605379399642-870262d3d051?w=400',
    'https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=400',
    'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400',
    'https://images.unsplash.com/photo-1515879218367-8466d910aeb9?w=400',
    'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=400',
    'https://images.unsplash.com/photo-1580927752452-89d86da3fa0a?w=400',
    'https://images.unsplash.com/photo-1607706189992-eae578626c86?w=400',
    'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final subtleGrey = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final chipBg = isDark ? Colors.grey.shade900 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // AppBar
            SliverAppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,
              scrolledUnderElevation: 0,
              pinned: true,
              floating: false,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.add, color: onSurface, size: 28),
                    Positioned(
                      top: 12,
                      right: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, color: onSurface, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '_itz.rohit',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: onSurface),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.keyboard_arrow_down, color: onSurface, size: 18),
                  const SizedBox(width: 6),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              actions: [
                Icon(Icons.alternate_email, color: onSurface, size: 26),
                const SizedBox(width: 20),
                Icon(Icons.menu, color: onSurface, size: 28),
                const SizedBox(width: 14),
              ],
            ),

            // Profile Info
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    // Profile Picture with music note bubble
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: subtleGrey, width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 42,
                            backgroundColor: Colors.grey,
                            backgroundImage: CachedNetworkImageProvider(
                              'https://i.pravatar.cc/300?u=itz_rohit_profile',
                            ),
                          ),
                        ),
                        // Blue + button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                        // Music note bubble
                        Positioned(
                          top: -20,
                          left: -10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: chipBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: subtleGrey, width: 0.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('🎵 ', style: TextStyle(fontSize: 10)),
                                    Text(
                                      'Paranoia',
                                      style: TextStyle(color: onSurface, fontSize: 10, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Text(
                                  'The Marías',
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Emoji on bubble
                        Positioned(
                          top: -28,
                          right: -4,
                          child: Text('🍏', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Stats
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn('posts', '18', onSurface),
                          _buildStatColumn('followers', '873', onSurface),
                          _buildStatColumn('following', '621', onSurface),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Username + Pronoun
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      'jinn :3',
                      style: TextStyle(color: onSurface, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'she',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // Bio
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '성훈 \'s only girl ✧˖°',
                      style: TextStyle(color: onSurface, fontSize: 14),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: onSurface, fontSize: 14),
                        children: [
                          const TextSpan(text: '( ☕ ) amoOooOr : '),
                          TextSpan(
                            text: '@enhypen',
                            style: TextStyle(color: Colors.blue.shade400),
                          ),
                          const TextSpan(text: ' !'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Music row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: onSurface, width: 1.2),
                      ),
                      child: Icon(Icons.play_arrow, color: onSurface, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No Way Back (feat. So!YoON!) • ENHYPEN',
                        style: TextStyle(color: onSurface, fontSize: 13, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: chipBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Edit profile',
                            style: TextStyle(color: onSurface, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: chipBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Share profile',
                            style: TextStyle(color: onSurface, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.person_add_outlined, color: onSurface, size: 18),
                    ),
                  ],
                ),
              ),
            ),

            // Highlights Section
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  itemCount: _highlights.length,
                  itemBuilder: (context, index) {
                    final h = _highlights[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: subtleGrey, width: 1.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey.shade800,
                                backgroundImage: CachedNetworkImageProvider(h['image']!),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 72,
                            child: Text(
                              h['label']!,
                              style: TextStyle(color: onSurface, fontSize: 11),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Tabs
            SliverPersistentHeader(
              pinned: true,
              delegate: _ProfileTabBarDelegate(
                tabBar: TabBar(
                  controller: _tabController,
                  indicatorColor: onSurface,
                  indicatorWeight: 1.5,
                  labelColor: onSurface,
                  unselectedLabelColor: Colors.grey.shade600,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on, size: 24)),
                    Tab(icon: Icon(Icons.ondemand_video, size: 24)),
                    Tab(icon: Icon(Icons.replay, size: 24)),
                    Tab(icon: Icon(Icons.person_pin_outlined, size: 24)),
                  ],
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Grid Tab
            _buildPhotoGrid(),
            // Reels Tab
            Center(child: Text('Reels', style: TextStyle(color: onSurface))),
            // Reposts Tab
            Center(child: Text('Reposts', style: TextStyle(color: onSurface))),
            // Tagged Tab
            Center(child: Text('Tagged', style: TextStyle(color: onSurface))),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: _gridImages.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: _gridImages[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey.shade900),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade900,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
            // Carousel indicator for some posts
            if (index % 4 == 0)
              Positioned(
                top: 6,
                right: 6,
                child: Icon(Icons.copy_rounded, color: Colors.white.withValues(alpha: 0.85), size: 16),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatColumn(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: color),
        ),
      ],
    );
  }
}

class _ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _ProfileTabBarDelegate({required this.tabBar, required this.backgroundColor});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _ProfileTabBarDelegate oldDelegate) => false;
}
