class Post {
  final String id;
  final String username;
  final String userProfileImage;
  final List<String> imageUrls;
  final String caption;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isLiked;
  final bool isSaved;

  Post({
    required this.id,
    required this.username,
    required this.userProfileImage,
    required this.imageUrls,
    required this.caption,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    this.isLiked = false,
    this.isSaved = false,
  });

  Post copyWith({
    String? id,
    String? username,
    String? userProfileImage,
    List<String>? imageUrls,
    String? caption,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    bool? isLiked,
    bool? isSaved,
  }) {
    return Post(
      id: id ?? this.id,
      username: username ?? this.username,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      imageUrls: imageUrls ?? this.imageUrls,
      caption: caption ?? this.caption,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
