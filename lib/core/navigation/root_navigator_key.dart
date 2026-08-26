import 'package:flutter/material.dart';

/// Shared with [ShareIntentListener] so it can push routes from outside the
/// widget tree when a file is shared into the app while it's running, and
/// with [AppLockGate] so it can show dialogs (e.g. the app-PIN prompt) from
/// outside the routed widget tree, where its own BuildContext has no
/// Navigator ancestor to find.
final rootNavigatorKey = GlobalKey<NavigatorState>();
