import 'package:e_tantana/features/auth/presentation/controller/auth_controller.dart';
import 'package:e_tantana/features/feedback/domain/entity/feedback_entity.dart';
import 'package:e_tantana/features/feedback/presentation/controller/feedback_controller.dart';
import 'package:e_tantana/features/feedback/presentation/star_rating_input.dart';
import 'package:e_tantana/features/feedback/presentation/states/chip_selector.dart';
import 'package:e_tantana/features/feedback/presentation/states/primary_button.dart';
import 'package:e_tantana/shared/widget/appBar/simple_appbar.dart';
import 'package:e_tantana/shared/widget/title/medium_title_with_degree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  List<String> _selectedCategories = [];

  final List<String> _categories = [
    "Interface",
    "Performance",
    "Livraison",
    "Support",
    "Prix",
    "Autre",
  ];

  bool get _canSubmit => _rating > 0;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final myFeedback = FeedbackEntity(
      rates: _rating,
      categoryOfFeedback: _selectedCategories,
      comment: _commentController.text,
      user_id: await ref.watch(authControllerProvider).user!.id,
    );
    await ref
        .read(feedbackControllerProvider.notifier)
        .createFeedback(myFeedback);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feebackStates = ref.watch(feedbackControllerProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: SimpleAppbar(
        onBack: () => Navigator.pop(context),
        title: "Votre avis",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section note
              MediumTitleWithDegree(
                showDegree: true,
                degree: 1,
                title: "Note globale",
              ),
              SizedBox(height: 16.h),
              StarRatingInput(
                initialRating: _rating,
                label: "Comment évaluez-vous votre expérience ?",
                onRatingChanged: (val) => setState(() => _rating = val),
              ),
              SizedBox(height: 32.h),

              // Section catégories
              MediumTitleWithDegree(
                showDegree: true,
                degree: 2,
                title: "Ce qui concerne votre avis",
              ),
              SizedBox(height: 16.h),
              ChipSelector(
                options: _categories,
                multiSelect: true,
                onSelectionChanged:
                    (val) => setState(() => _selectedCategories = val),
              ),
              SizedBox(height: 32.h),

              // Section commentaire
              MediumTitleWithDegree(
                showDegree: true,
                degree: 3,
                title: "Commentaire",
              ),
              SizedBox(height: 16.h),
              _buildCommentInput(context),
              SizedBox(height: 40.h),

              // Bouton submit
              PrimaryButton(
                label: "Envoyer mon avis",
                icon: HugeIcons.strokeRoundedSent,
                isLoading: feebackStates.isLoading,
                onTap: _canSubmit ? _submit : null,
              ),

              // Message si note pas encore donnée
              if (!_canSubmit) ...[
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    "Donnez une note pour continuer",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      child: TextField(
        controller: _commentController,
        maxLines: 5,
        minLines: 3,
        maxLength: 500,
        style: TextStyle(
          fontSize: 13.sp,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Décrivez votre expérience...",
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.35),
          ),
          counterStyle: TextStyle(
            fontSize: 11.sp,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
