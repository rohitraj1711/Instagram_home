import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/feed_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/story_list.dart';
import '../widgets/shimmer_post.dart';
import '../../settings/screens/profile_screen.dart';

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
          const Center(child: Text("Search Tab")),
          const Center(child: Text("Add Post Tab")),
          const Center(child: Text("Reels Tab")),
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
              icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1 ? Icons.search : Icons.search_outlined, size: 28),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_box_outlined),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3 ? Icons.ondemand_video : Icons.ondemand_video_outlined),
              label: 'Reels',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 4 ? Icons.person : Icons.person_outline),
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
      title: Text(
        'Instagram',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.favorite_border, color: Theme.of(context).iconTheme.color, size: 28),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.maps_ugc_outlined, color: Theme.of(context).iconTheme.color, size: 28),
                onPressed: () {},
              ),
              Positioned(
                top: 10,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
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

          // Shimmer effect loading logic when 0 posts exist
          if (feedState.posts.isEmpty && feedState.isLoading)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return const ShimmerPost();
                },
                childCount: 3,
              ),
            )
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
