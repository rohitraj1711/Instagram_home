import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../repository/post_repository.dart';

// Provides a singleton-like instance of the repository
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

class FeedState {
  final List<Post> posts;
  final bool isLoading;
  final bool hasReachedMax;
  final int currentPage;
  final String? error;

  FeedState({
    this.posts = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.error,
  });

  FeedState copyWith({
    List<Post>? posts,
    bool? isLoading,
    bool? hasReachedMax,
    int? currentPage,
    String? error,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      error: error ?? this.error,
    );
  }
}

class FeedNotifier extends Notifier<FeedState> {
  late PostRepository _repository;

  @override
  FeedState build() {
    _repository = ref.watch(postRepositoryProvider);
    return FeedState();
  }

  /// Fetch initial posts or paginate next pages
  Future<void> fetchPosts({bool isRefresh = false}) async {
    // Prevent fetching if already loading
    if (state.isLoading) return;
    // Prevent fetching if we've reached the end and it's not a refresh
    if (!isRefresh && state.hasReachedMax) return;

    try {
      if (isRefresh) {
        state = state.copyWith(isLoading: true, currentPage: 1, error: null, hasReachedMax: false);
      } else {
        state = state.copyWith(isLoading: true, error: null);
      }

      final pageToFetch = isRefresh ? 1 : state.currentPage;
      final newPosts = await _repository.fetchPosts(pageToFetch);

      if (newPosts.isEmpty) {
        state = state.copyWith(
          isLoading: false, 
          hasReachedMax: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          posts: isRefresh ? newPosts : [...state.posts, ...newPosts],
          currentPage: pageToFetch + 1,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch posts: $e',
      );
    }
  }

  /// Toggle like status for a local post optimistic update
  void toggleLike(String postId) {
    state = state.copyWith(
      posts: state.posts.map((post) {
        if (post.id == postId) {
          final isCurrentlyLiked = post.isLiked;
          return post.copyWith(
            isLiked: !isCurrentlyLiked,
            likesCount: post.likesCount + (isCurrentlyLiked ? -1 : 1),
          );
        }
        return post;
      }).toList(),
    );
  }

  /// Toggle save status for a local post optimistic update
  void toggleSave(String postId) {
    state = state.copyWith(
      posts: state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(isSaved: !post.isSaved);
        }
        return post;
      }).toList(),
    );
  }
}

// Global provider for accessing the feed state and logic via Riverpod
final feedProvider = NotifierProvider<FeedNotifier, FeedState>(() {
  return FeedNotifier();
});
