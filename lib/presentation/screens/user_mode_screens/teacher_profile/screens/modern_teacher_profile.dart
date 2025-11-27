import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/input/star_rating_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/widgets/modern_review_card.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/widgets/modern_teacher_header.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/widgets/teacher_events_section.dart';
import 'package:acroworld/provider/riverpod_provider/comments_provider.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_statistics_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/helper_functions/auth_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModernTeacherProfile extends ConsumerStatefulWidget {
  const ModernTeacherProfile({
    super.key,
    required this.teacher,
    required this.isLiked,
    required this.loading,
    required this.onFollowPressed,
    required this.onBackPressed,
  });

  final TeacherModel teacher;
  final bool isLiked;
  final bool loading;
  final VoidCallback onFollowPressed;
  final VoidCallback onBackPressed;

  @override
  ConsumerState<ModernTeacherProfile> createState() =>
      _ModernTeacherProfileState();
}

class _ModernTeacherProfileState extends ConsumerState<ModernTeacherProfile> {
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;
  bool _isSubmittingComment = false;
  String? _existingCommentId;
  bool _isEditMode = false;
  bool _showReviewForm = false;

  @override
  void initState() {
    super.initState();
    // Load comments when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(commentsNotifierProvider.notifier)
          .loadComments(widget.teacher.id!);
    });

    // Add listener to text controller to trigger rebuild
    _commentController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  bool _canSubmit() {
    final hasRating = _selectedRating > 0;
    final hasText = _commentController.text.trim().isNotEmpty;
    return hasRating && hasText;
  }

  Future<void> _deleteComment() async {
    if (_existingCommentId == null) return;

    final currentUser = ref.read(userRiverpodProvider).value;
    if (currentUser == null) {
      showAuthRequiredDialog(
        context,
        subtitle: 'Log in or sign up to delete your review.',
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text(
            'Are you sure you want to delete your review? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      await ref
          .read(commentsNotifierProvider.notifier)
          .deleteComment(_existingCommentId!);

      // Refresh the user comment provider to update the Consumer
      ref.invalidate(userCommentProvider(widget.teacher.id!));

      // Reload comments statistics to update rating and review count immediately
      ref
          .read(teacherStatisticsNotifierProvider(widget.teacher.id!).notifier)
          .loadCommentsStats();

      // Clear the form
      _commentController.clear();
      setState(() {
        _selectedRating = 0;
        _isEditMode = false;
        _existingCommentId = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete review: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingComment = false;
        });
      }
    }
  }

  Future<void> _submitComment() async {
    final currentUser = ref.read(userRiverpodProvider).value;
    if (currentUser == null) {
      showAuthRequiredDialog(
        context,
        subtitle: 'Log in or sign up to leave a review for this teacher.',
      );
      return;
    }

    // Check if user already has a comment and is not in edit mode
    if (!_isEditMode && _existingCommentId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'You already have a review for this teacher. Please edit your existing review instead.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      await ref.read(commentsNotifierProvider.notifier).addOrUpdateComment(
            _commentController.text.trim(),
            _selectedRating,
            widget.teacher.id!,
            commentId: _existingCommentId,
          );

      // Refresh the user comment provider to update the Consumer
      ref.invalidate(userCommentProvider(widget.teacher.id!));

      // Reload comments statistics to update rating and review count immediately
      ref
          .read(teacherStatisticsNotifierProvider(widget.teacher.id!).notifier)
          .loadCommentsStats();

      // Don't clear the form immediately - let the Consumer handle it
      // The Consumer will detect the updated comment and populate the form

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode
                ? 'Review updated successfully!'
                : 'Review submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to ${_isEditMode ? 'update' : 'submit'} review: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingComment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Events will be loaded by the TeacherEventsSection widget

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Modern header with image carousel
          SliverToBoxAdapter(
            child: ModernTeacherHeader(
              teacher: widget.teacher,
              images: widget.teacher.images
                      ?.map((img) => img.image?.url ?? '')
                      .toList() ??
                  [],
              currentImageIndex: _currentImageIndex,
              onImageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              imagePageController: _imagePageController,
              isLiked: widget.isLiked,
              loading: widget.loading,
              onFollowPressed: widget.onFollowPressed,
              onBackPressed: widget.onBackPressed,
            ),
          ),

          // Events Section
          SliverToBoxAdapter(
            child: TeacherEventsSection(teacherId: widget.teacher.id!),
          ),

          // Reviews Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to full reviews page
                    },
                    child: Text(
                      'View All',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Reviews List
          Consumer(
            builder: (context, ref, child) {
              final commentsAsync = ref.watch(commentsNotifierProvider);

              return commentsAsync.when(
                data: (reviews) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < reviews.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: ModernReviewCard(review: reviews[index]),
                        );
                      }
                      return null;
                    },
                    childCount: reviews.length,
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (error, stack) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'Error loading reviews: $error',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Add Comment Section
          SliverToBoxAdapter(
            child: Consumer(
              builder: (context, ref, child) {
                final userCommentAsync =
                    ref.watch(userCommentProvider(widget.teacher.id!));

                return userCommentAsync.when(
                  data: (existingComment) {
                    // Update form state when comment data is available
                    if (existingComment != null) {
                      // Comment exists - switch to edit mode and populate form
                      if (!_isEditMode ||
                          _existingCommentId != existingComment.id) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _existingCommentId = existingComment.id;
                            _isEditMode = true;
                            _commentController.text = existingComment.content;
                            _selectedRating = existingComment.rating;
                          });
                        });
                      }
                    } else if (existingComment == null && _isEditMode) {
                      // Comment was deleted, reset form to create mode
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _isEditMode = false;
                          _existingCommentId = null;
                          _commentController.clear();
                          _selectedRating = 0;
                        });
                      });
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          if (!_showReviewForm) ...[
                            // Show comment button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final currentUser = ref.read(userRiverpodProvider).value;
                                  if (currentUser == null) {
                                    showAuthRequiredDialog(
                                      context,
                                      subtitle: 'Log in or sign up to leave a review for this teacher.',
                                    );
                                    return;
                                  }
                                  setState(() {
                                    _showReviewForm = true;
                                  });
                                },
                                icon: Icon(
                                  existingComment != null
                                      ? Icons.edit
                                      : Icons.comment_outlined,
                                ),
                                label: Text(
                                  existingComment != null
                                      ? 'Edit Comment'
                                      : 'Comment',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            // Show review form
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: colorScheme.outline.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _isEditMode
                                                ? 'Edit Your Review'
                                                : 'Leave a Review',
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _showReviewForm = false;
                                            });
                                          },
                                          icon: const Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                                    if (_isEditMode) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: colorScheme.primary
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: colorScheme.primary,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'You already have a review for this teacher. You can edit or delete it below.',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _commentController,
                                      decoration: InputDecoration(
                                        hintText: 'Share your experience...',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: colorScheme.outline
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: colorScheme.outline
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: colorScheme.primary,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                      ),
                                      maxLines: 4,
                                      maxLength: 500,
                                    ),
                                    const SizedBox(height: 16),
                                    StarRatingWidget(
                                      initialRating: _selectedRating,
                                      onRatingChanged: (rating) {
                                        setState(() {
                                          _selectedRating = rating;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        if (_isEditMode) ...[
                                          IconButton(
                                            onPressed: _isSubmittingComment
                                                ? null
                                                : () => _deleteComment(),
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: colorScheme.error,
                                            ),
                                            tooltip: 'Delete review',
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                        Expanded(
                                          flex: 2,
                                          child: ElevatedButton(
                                            onPressed: _canSubmit()
                                                ? () => _submitComment()
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  colorScheme.primary,
                                              foregroundColor: Colors.white,
                                              disabledBackgroundColor:
                                                  colorScheme
                                                      .surfaceContainerHighest,
                                              disabledForegroundColor:
                                                  colorScheme.onSurfaceVariant,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 12,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: _isSubmittingComment
                                                ? const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                                  )
                                                : Text(_isEditMode
                                                    ? 'Update'
                                                    : 'Submit'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                  loading: () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: null, // Disabled while loading
                        icon: const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        label: const Text('Loading...'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.error.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: colorScheme.error,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error loading comment form',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to retry',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.error.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}
