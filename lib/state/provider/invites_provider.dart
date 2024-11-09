import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/data/repositories/invitation_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';

class InvitesProvider extends ChangeNotifier {
  final InvitationRepository _invitationRepository;

  List<InvitationModel> invites = [];
  int _totalInvites = 0;
  final int _limit = 10;
  int _offset = 0;
  bool loading = true;

  bool get canFetchMore => invites.length < _totalInvites;

  InvitesProvider({required InvitationRepository invitationRepository})
      : _invitationRepository = invitationRepository;

  // tries to invite a user by email and shows a succestoast if successful or an error toast if not
  // returns true if successful and false if not
  Future<bool> inviteByEmail(String email) async {
    if (await checkIfInviteIsPossible(email) == false) {
      return false;
    }
    try {
      final result = await _invitationRepository.inviteByEmail(email);
      if (result) {
        showSuccessToast("Invitation sent to $email");
        // fetch invitations again to show the new one
        await getInvitations(isRefresh: true);
        return true;
      } else {
        showErrorToast("Failed to send invitation to $email");
        return false;
      }
    } catch (e, s) {
      // TODO switch to user friednly message and handle this not in provider
      showErrorToast(e.toString());
      CustomErrorHandler.captureException(e, stackTrace: s);
      return false;
    }
  }

  Future<void> getInvitations({bool isRefresh = true}) async {
    loading = true;
    if (isRefresh) {
      _offset = 0;
      invites = [];
    }
    try {
      final result =
          await _invitationRepository.getInvitations(_limit, _offset);

      print("Invites: $result");
      invites.addAll(result["invitations"]);
      _totalInvites = result["count"];
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }

    loading = false;
    notifyListeners();
  }

  // fetch more
  Future<void> fetchMore() async {
    _offset += _limit;
    notifyListeners();
    await getInvitations(isRefresh: false);
  }

  // check if invite is possible
  Future<bool> checkIfInviteIsPossible(String email) async {
    try {
      final result = await _invitationRepository.checkInvitePossibility(email);
      if (result["isInvitedByYou"] == true) {
        showErrorToast("You have already invited this user");
        return false;
      } else if (result["isAlreadyRegistered"] == true) {
        showErrorToast("This user is already registered");
        return false;
      } else {
        return true;
      }
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
      showErrorToast("Failed to check if invite is possible");
      return false;
    }
  }
}
