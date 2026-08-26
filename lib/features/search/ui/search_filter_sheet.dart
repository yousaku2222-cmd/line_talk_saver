import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../providers/message_filter.dart';

/// Shows the sender/date-range/text filter sheet and returns the chosen
/// filter, or null if the user dismissed it without applying anything.
Future<MessageFilter?> showSearchFilterSheet(
  BuildContext context, {
  required Map<int, String> senders,
  required MessageFilter current,
}) {
  return showModalBottomSheet<MessageFilter>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _SearchFilterSheet(senders: senders, initial: current),
  );
}

class _SearchFilterSheet extends StatefulWidget {
  const _SearchFilterSheet({required this.senders, required this.initial});

  final Map<int, String> senders;
  final MessageFilter initial;

  @override
  State<_SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<_SearchFilterSheet> {
  late Set<int> _selectedSenderIds;
  late DateTimeRange? _dateRange;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _selectedSenderIds = {...?widget.initial.senderIds};
    _dateRange = widget.initial.dateRange;
    _textController = TextEditingController(text: widget.initial.textQuery ?? '');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.filterTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text(l10n.textSearchLabel, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: l10n.keywordHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.senderLabel, style: Theme.of(context).textTheme.labelLarge),
            Wrap(
              spacing: 8,
              children: [
                for (final entry in widget.senders.entries)
                  FilterChip(
                    label: Text(entry.value),
                    selected: _selectedSenderIds.contains(entry.key),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSenderIds.add(entry.key);
                        } else {
                          _selectedSenderIds.remove(entry.key);
                        }
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.periodLabel, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickDateRange,
              icon: const Icon(Icons.date_range),
              label: Text(
                _dateRange == null
                    ? l10n.periodPickerButton
                    : l10n.periodRangeFormat(
                        dateFormat.format(_dateRange!.start),
                        dateFormat.format(_dateRange!.end),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedSenderIds = {};
                        _dateRange = null;
                        _textController.clear();
                      });
                    },
                    child: Text(l10n.clearButton),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(
                      MessageFilter(
                        senderIds:
                            _selectedSenderIds.isEmpty ? null : _selectedSenderIds,
                        dateRange: _dateRange,
                        textQuery: _textController.text.trim().isEmpty
                            ? null
                            : _textController.text.trim(),
                      ),
                    ),
                    child: Text(l10n.applyButton),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
