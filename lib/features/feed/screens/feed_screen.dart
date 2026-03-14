import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/feed_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/story_list.dart';
import '../widgets/shimmer_post.dart';
import '../../settings/screens/profile_screen.dart';
import '../../chat/screens/chat_screen.dart';
import '../../search/screens/search_screen.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0; // State for bottom nav bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial posts on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedProvider.notifier).fetchPosts(isRefresh: true);
    });

    // Setup infinite scroll pagination listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _fetchPaginatedPosts();
      }
    });
  }

  void _fetchPaginatedPosts() {
     // Explicit check to prevent duplicate fetches when already loading
     if (ref.read(feedProvider).isLoading) return;
     ref.read(feedProvider.notifier).fetchPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(feedProvider.notifier).fetchPosts(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // We only show the custom Feed AppBar when on the Home tab
      appBar: _selectedIndex == 0 ? _buildFeedAppBar(context) : null,
      
      // IndexedStack switches tabs quickly while preserving their child state
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeFeedTab(context),
          const Center(child: Text("Reels Tab")),
          const ChatScreen(),
          const SearchScreen(),
          const ProfileScreen(), // Tab 4 handles Profile Layout & Settings
        ],
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          iconSize: 28,
          selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                size: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1 ? Icons.smart_display : Icons.smart_display_outlined,
                size: 28,
              ),
              label: 'Reels',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Transform.rotate(
                    angle: -0.35,
                    child: Icon(
                      _selectedIndex == 2 ? Icons.send : Icons.send_outlined,
                      size: 26,
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -4,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 1.5),
                      ),
                    ),
                  )
                ],
              ),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 ? Icons.search : Icons.search_outlined,
                size: 30,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedIndex == 4
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 12,
                  backgroundImage: CachedNetworkImageProvider(
                    'https://i.pravatar.cc/100?u=itz_rohit_nav',
                  ),
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildFeedAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.add, color: Theme.of(context).iconTheme.color, size: 28),
        onPressed: () {},
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Instagram',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: Theme.of(context).iconTheme.color),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border, color: Theme.of(context).iconTheme.color, size: 28),
                onPressed: () {},
              ),
              Positioned(
                top: 10,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomeFeedTab(BuildContext context) {
    final feedState = ref.watch(feedProvider);

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Theme.of(context).colorScheme.onSurface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 1. Stories Row
          const SliverToBoxAdapter(
            child: StoryList(),
          ),

          // Shimmer effect: full shimmer layout during initial 1.5s load
          if (feedState.posts.isEmpty && feedState.isLoading) ...[
            // Shimmer stories tray
            const SliverToBoxAdapter(
              child: ShimmerStoryList(),
            ),
            // Shimmer post cards
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return const ShimmerPost();
                },
                childCount: 3,
              ),
            ),
          ]
          // Error handling fallback State
          else if (feedState.posts.isEmpty && feedState.error != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(feedState.error!, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _onRefresh,
                      child: const Text('Try Again'),
                    )
                  ],
                ),
              ),
            )
          // Empty Feed state handler
          else if (feedState.posts.isEmpty && !feedState.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No posts available right now.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          // Actual Cached Posts Builder State
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return PostCard(post: feedState.posts[index]);
                },
                childCount: feedState.posts.length,
              ),
            ),
            
          // End of ListView loading indicator OR finished indicator
          if (feedState.posts.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: feedState.hasReachedMax
                    ? const Column(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green, size: 36),
                          SizedBox(height: 8),
                          Text("You're all caught up", style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
