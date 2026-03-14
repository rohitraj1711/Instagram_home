import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'story_avatar.dart';

class StoryList extends ConsumerWidget {
  const StoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Simulated mixed mock data for diverse Indian and English names
    final List<Map<String, String>> mockStoryUsers = [
      {'name': 'Your Story', 'image': ''},
      {'name': 'rohan_gupta', 'image': 'https://picsum.photos/seed/rohan/150/150'},
      {'name': 'sarah.janes', 'image': 'https://picsum.photos/seed/sarah/150/150'},
      {'name': 'priya_sharma', 'image': 'https://picsum.photos/seed/priya/150/150'},
      {'name': 'mike.williams', 'image': 'https://picsum.photos/seed/mike/150/150'},
      {'name': 'amit_verma', 'image': 'https://picsum.photos/seed/amit/150/150'},
      {'name': 'emily_clark', 'image': 'https://picsum.photos/seed/emily/150/150'},
      {'name': 'neha.singh99', 'image': 'https://picsum.photos/seed/neha/150/150'},
      {'name': 'josh_baker', 'image': 'https://picsum.photos/seed/josh/150/150'},
      {'name': 'kabir_das', 'image': 'https://picsum.photos/seed/kabir/150/150'},
      {'name': 'lucy.heart', 'image': 'https://i.pravatar.cc/150?u=lucy'},
      {'name': 'ananya.p', 'image': 'https://i.pravatar.cc/150?u=ananya'},
      {'name': 'charlie123', 'image': 'https://i.pravatar.cc/150?u=charlie'},
      {'name': 'rahul_m', 'image': 'https://i.pravatar.cc/150?u=rahul'},
      {'name': 'bella_swan', 'image': 'https://i.pravatar.cc/150?u=bella'},
    ];

    return SizedBox(
      height: 105, // Container height for stories + padding
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockStoryUsers.length,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              itemBuilder: (context, index) {
                final user = mockStoryUsers[index];
                
                if (index == 0) {
                  return StoryAvatar(
                    imageUrl: user['image']!, 
                    username: user['name']!,
                    isAddStory: true,
                    radius: 33,
                  );
                }
                
                return StoryAvatar(
                  imageUrl: user['image']!,
                  username: user['name']!,
                  radius: 33,
                );
              },
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F1F1)),
        ],
      ),
    );
  }
}
