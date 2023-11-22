import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String avatarUrl; // URL for the user's avatar image
  final String? title; // Optional title for the user

  const ProfileHeader({
    Key? key,
    required this.userName,
    required this.avatarUrl,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(avatarUrl),
            // For local asset, you'd use `AssetImage('path/to/asset')`
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (title != null) ...[
                const SizedBox(height: 4.0),
                Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
