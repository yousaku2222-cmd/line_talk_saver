import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../stats_image_share.dart';

/// A titled card used by both the per-chat stats screen and the
/// cross-chat dashboard. Its content (title + child) is wrapped in a
/// [RepaintBoundary] so the share button can render it straight to a PNG
/// for sharing (see [shareWidgetAsImage]).
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final boundaryKey = GlobalKey();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: RepaintBoundary(
        key: boundaryKey,
        child: Container(
          color: scheme.surfaceContainerLow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.ios_share, size: 18),
                    tooltip: l10n.statsShareImageTooltip,
                    onPressed: () =>
                        shareWidgetAsImage(boundaryKey, fileName: title),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
