import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:neumorphic_calculator/utils/extensions/theme_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class MadeByWidget extends StatelessWidget {
  const MadeByWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.isDarkMode;
    final contentTextStyle = theme.textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.white : Colors.black,
        );
    final githubIconPath = isDark ? AppConst.githubLight : AppConst.githubDark;
    return InkWell(
      onTap: () async {
        try {
          await launchUrl(Uri.parse(AppConst.githubLink));
        } catch (_) {}
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '@2025 Neumorphic Calculator',
                    style: contentTextStyle?.copyWith(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    'Made with ❤️ by Mohammed Ragheb',
                    style: contentTextStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await launchUrl(Uri.parse(AppConst.githubLink));
                } catch (_) {}
              },
              icon: Lottie.asset(
                githubIconPath,
                width: 50,
                height: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
