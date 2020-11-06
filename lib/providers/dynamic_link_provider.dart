import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:let_log/let_log.dart';
import 'package:swapTech/providers/auth_provider.dart';

enum LinkStatus { NoLink, LoggedIn, NotLoggedIn }

class DynamicLinkProvider {
  LinkStatus linkStatus = LinkStatus.NoLink;
  // Completer<LinkStatus> completer = Completer<LinkStatus>();
  String linkShareUserId;
  final AuthProvider authProvider;
  DynamicLinkProvider(this.authProvider) {
    setupDynamicLink();
  }

  void setupDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (data != null) {
      await handleDeepLink(data);
    } else {
      authProvider.onLinkStatusChanged.value = LinkStatus.NoLink;
    }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (dynamicLink) async => await handleDeepLink(dynamicLink),
      onError: (error) {
        Logger.error("DYNAMIC LINK ONLINK ERROR ", error);
        linkStatus = LinkStatus.NoLink;
        authProvider.onLinkStatusChanged.value = linkStatus;
        return null;
      },
    );
  }

  Future handleDeepLink(dynamicLink) async {
    try {
      authProvider.onLinkStatusChanged.value = LinkStatus.NoLink;

      final Uri deepLink = dynamicLink?.link;
      print("HERE IS THE DEEP LINK PATH SEGMENTS ${deepLink.pathSegments}");
      final userId = deepLink?.pathSegments?.first;

      if (userId != null) {
        linkShareUserId = userId;
        if (await FirebaseAuth.instance.currentUser() == null) {
          Logger.error("NO LOGGED IN USER ");
          linkStatus = LinkStatus.NotLoggedIn;
          authProvider.onLinkStatusChanged.value = linkStatus;
          return;
        }

        linkStatus = LinkStatus.LoggedIn;
        authProvider.onLinkStatusChanged.value = linkStatus;

        print("LINKSTATUS CHAGED TO $linkStatus");
      }
    } catch (e) {
      print(e.runtimeType);
      Logger.error("PATH SEGMENT INDEX ERROR ", e);
    }
  }
}
