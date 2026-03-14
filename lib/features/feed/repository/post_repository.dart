import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/post.dart';

class PostRepository {
  final _uuid = const Uuid();
  final _random = Random();

  Future<List<Post>> fetchPosts(int page, {int limit = 5}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Simulate pagination end (100 pages for infinite scroll feel)
    if (page > 100) return [];

    return List.generate(limit, (index) {
      final postId = _uuid.v4();
      final imageCount = _random.nextInt(3) + 1; // 1 to 3 images per post (for carousel)
      
      final mixedNames = ['rohan_gupta', 'sarah.janes', 'priya_sharma', 'mike.williams', 'amit_verma', 'emily_clark', 'neha.singh99', 'josh_baker', 'kabir_das', 'lucy.heart', 'ananya.p', 'charlie123', 'rahul_m', 'bella_swan'];
      final uName = mixedNames[_random.nextInt(mixedNames.length)];
      
      return Post(
        id: postId,
        username: uName,
        userProfileImage: 'https://i.pravatar.cc/150?u=$uName',
        imageUrls: List.generate(
          imageCount,
          (imgIndex) => 'https://picsum.photos/seed/${postId}_$imgIndex/600/800', // Vertical photos
        ),
        caption: 'This is an amazing post generated for testing pixel-perfect UI. #flutter #instagram @flutterdev',
        likesCount: _random.nextInt(10000),
        commentsCount: _random.nextInt(500),
        createdAt: DateTime.now().subtract(Duration(hours: _random.nextInt(48))),
        isLiked: _random.nextBool(),
        isSaved: _random.nextBool(),
      );
    });
  }
}
