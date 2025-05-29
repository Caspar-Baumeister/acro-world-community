// lib/presentation/screens/settings/delete_account.dart

import 'package:acroworld/exceptions/auth_exception.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteAccount extends ConsumerStatefulWidget {
  const DeleteAccount({super.key});

  @override
  ConsumerState<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends ConsumerState<DeleteAccount> {
  bool _loading = false;

  Future<void> _confirmAndDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text(
          "Are you sure you want to delete your profile? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _loading = true);

    try {
      await ref.read(authProvider.notifier).deleteAccount();
      showSuccessToast("Your account was deleted");
      // GoRouter redirect to /auth will happen automatically via authProvider
    } on AuthException catch (e) {
      showErrorToast(e.error);
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      showErrorToast("Something went wrong. Please try again later.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: _loading ? null : _confirmAndDelete,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: _loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                "Delete account",
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
      ),
    );
  }
}
