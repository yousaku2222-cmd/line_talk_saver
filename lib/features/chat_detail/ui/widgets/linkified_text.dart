import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final _urlPattern = RegExp(r'(https?://\S+)');

/// Renders [text], turning any `http(s)://` URL inside it into a tappable
/// link that opens in the device's browser -- LINE chat exports routinely
/// contain shared links (maps, articles, etc.) as plain text.
class LinkifiedText extends StatelessWidget {
  const LinkifiedText(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final matches = _urlPattern.allMatches(text).toList();
    if (matches.isEmpty) {
      return Text(text, style: style);
    }

    final baseStyle = DefaultTextStyle.of(context).style.merge(style);
    final linkStyle = baseStyle.copyWith(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      final url = match.group(0)!;
      spans.add(
        TextSpan(
          text: url,
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              final uri = Uri.tryParse(url);
              if (uri != null) launchUrl(uri, mode: LaunchMode.externalApplication);
            },
        ),
      );
      cursor = match.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return Text.rich(TextSpan(style: baseStyle, children: spans));
  }
}
