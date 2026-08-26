import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../app_lock_prefs.dart';
import '../app_lock_service.dart';
import '../app_pin_prefs.dart';

/// Wraps the whole app; when app-lock is enabled it shows a lock screen on
/// cold start and whenever the app returns from the background, requiring
/// authentication before revealing [child].
///
/// When an app PIN is set (see app_pin_prefs.dart) it's entered inline,
/// right here, rather than via `showDialog` -- this widget's own context
/// sits *above* the app's Navigator (it wraps MaterialApp.builder's child),
/// so it has no Navigator ancestor for a dialog to attach to. Routing the
/// dialog through the Navigator inside `widget.child` was tried, but that
/// Navigator (and its Overlay) is a *sibling* stacked *below* this lock
/// screen in the Stack below, so the dialog rendered invisibly behind an
/// opaque barrier it could never be dismissed -- forever, since the button
/// that would have retried was left disabled the whole time waiting on it.
/// An inline field sidesteps needing a Navigator at all.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  bool _locked = false;
  bool _authenticating = false;
  bool _showPinField = false;
  String? _errorMessage;
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (ref.read(appLockEnabledProvider)) {
      _locked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pinController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!ref.read(appLockEnabledProvider)) return;
    if (state == AppLifecycleState.paused) {
      setState(() {
        _locked = true;
        _showPinField = false;
      });
    } else if (state == AppLifecycleState.resumed && _locked) {
      _unlock();
    }
  }

  /// The app PIN, when set, takes priority (see requestAuthentication in
  /// authenticate.dart, which the rest of the app's lock UI uses) -- here
  /// that just means revealing the inline field instead of immediately
  /// calling out to the device. Device auth needs no Navigator (it's a
  /// native platform prompt), so that path is unaffected by the dialog
  /// issue described above.
  Future<void> _unlock() async {
    if (_authenticating) return;
    if (ref.read(appPinSetProvider)) {
      setState(() {
        _showPinField = true;
        _errorMessage = null;
      });
      return;
    }
    setState(() => _authenticating = true);
    try {
      final reason = AppLocalizations.of(context)!.appLockAuthReason;
      final ok = await AppLockService().authenticate(reason: reason);
      if (ok && mounted) {
        setState(() => _locked = false);
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _authenticating = false);
    }
  }

  void _submitPin() {
    if (verifyAppPin(ref, _pinController.text.trim())) {
      _pinController.clear();
      setState(() {
        _locked = false;
        _showPinField = false;
        _errorMessage = null;
      });
    } else {
      setState(() => _errorMessage = AppLocalizations.of(context)!.appPinIncorrectMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // The real content (including the Navigator that share-intent handling
    // pushes routes onto) stays mounted underneath at all times, even while
    // locked -- if it were swapped out entirely, a LINE share arriving
    // while locked would silently fail to navigate (the Navigator wouldn't
    // exist yet for `rootNavigatorKey.currentState` to push onto) and the
    // shared content would be lost by the time the user unlocks.
    return Stack(
      children: [
        widget.child,
        if (_locked)
          Positioned.fill(
            child: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(l10n.lockedMessage),
                      const SizedBox(height: 24),
                      if (_showPinField) ...[
                        SizedBox(
                          width: 220,
                          child: TextField(
                            controller: _pinController,
                            autofocus: true,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            maxLength: 6,
                            decoration: InputDecoration(hintText: l10n.appPinHint),
                            onSubmitted: (_) => _submitPin(),
                          ),
                        ),
                        FilledButton(
                          onPressed: _submitPin,
                          child: Text(l10n.unlockButtonLabel),
                        ),
                      ] else
                        FilledButton.icon(
                          onPressed: _authenticating ? null : _unlock,
                          icon: const Icon(Icons.fingerprint),
                          label: Text(l10n.unlockButtonLabel),
                        ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
