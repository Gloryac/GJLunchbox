import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TextStrings.featured,
          style: AppTextTheme.textStyles.headlineSmall, // Updated to use custom text styles
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFeaturedCard(
                TextStrings.featuredTitle1,
                TextStrings.featuredAuthor1,
                TextStrings.featuredTime1,
              ),
              _buildFeaturedCard(
                TextStrings.featuredTitle2,
                TextStrings.featuredAuthor2,
                TextStrings.featuredTime2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(String title, String author, String time) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 264,
          color: Colors.grey.shade200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey.shade400,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: AppTextTheme.textStyles.labelLarge, // Updated for title
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  author,
                  style: AppTextTheme.textStyles.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ), // Updated for author
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  time,
                  style: AppTextTheme.textStyles.bodySmall?.copyWith(
                    color: Colors.grey,
                  ), // Updated for time
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
