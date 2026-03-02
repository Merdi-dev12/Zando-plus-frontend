import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.navAccount, style: AppTextStyles.appBarTitle),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline_rounded,
                size: 72, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(AppStrings.loginPrompt,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}