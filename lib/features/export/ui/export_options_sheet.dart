import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/tokens.dart';
import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../chat_stats/chat_stats_calculator.dart';
import '../docx/export_docx.dart';
import '../excel/export_excel.dart';
import '../pdf/export_pdf.dart';
import '../stats_summary_lines.dart';

/// Shows a sheet letting the user pick Excel / PDF / Word, generates the
/// file, and hands it to the OS share sheet.
Future<void> showExportOptionsSheet(
  BuildContext context, {
  required String chatTitle,
  required List<Message> messages,
  required Map<int, String> senderNames,
}) {
  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).toString();
  return showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      var includeStats = false;

      return StatefulBuilder(
        builder: (sheetContext, setState) {
          List<String>? statsLines() {
            if (!includeStats) return null;
            final stats = ChatStatsCalculator.compute(messages, senderNames);
            if (stats.totalMessages == 0) return null;
            return buildStatsSummaryLines(l10n, stats, locale);
          }

          void run(
            Future<File> Function({required List<String>? statsLines}) build,
          ) {
            Navigator.of(sheetContext).pop();
            _export(context, build: () => build(statsLines: statsLines()));
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.x1,
                AppSpacing.screen,
                AppSpacing.x5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.x3),
                    child: Text(
                      l10n.exportFormatTitle,
                      style: Theme.of(sheetContext).textTheme.titleMedium,
                    ),
                  ),
                  _ExportOption(
                    icon: Icons.table_chart_outlined,
                    label: l10n.excelOption,
                    onTap: () => run(
                      ({required statsLines}) => buildExcelFile(
                        l10n: l10n,
                        chatTitle: chatTitle,
                        messages: messages,
                        senderNames: senderNames,
                        statsLines: statsLines,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ExportOption(
                    icon: Icons.picture_as_pdf_outlined,
                    label: l10n.pdfOption,
                    onTap: () => run(
                      ({required statsLines}) => buildPdfFile(
                        l10n: l10n,
                        chatTitle: chatTitle,
                        messages: messages,
                        senderNames: senderNames,
                        statsLines: statsLines,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ExportOption(
                    icon: Icons.description_outlined,
                    label: l10n.wordOption,
                    onTap: () => run(
                      ({required statsLines}) => buildDocxFile(
                        l10n: l10n,
                        chatTitle: chatTitle,
                        messages: messages,
                        senderNames: senderNames,
                        statsLines: statsLines,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  CheckboxListTile(
                    value: includeStats,
                    onChanged: (v) => setState(() => includeStats = v ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.exportIncludeStatsLabel),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _ExportOption extends StatelessWidget {
  const _ExportOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: scheme.outline),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: scheme.onPrimaryContainer, size: 22),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _export(
  BuildContext context, {
  required Future<File> Function() build,
}) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final file = await build();
    if (!context.mounted) return;
    Navigator.of(context).pop(); // close loading dialog
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  } catch (e) {
    if (!context.mounted) return;
    Navigator.of(context).pop(); // close loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.exportFailedMessage(e)),
      ),
    );
  }
}
