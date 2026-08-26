/// Arguments for opening [ImportScreen] pre-loaded from an OS share event,
/// either a `.txt` file on disk or raw shared text content.
class ImportScreenArgs {
  const ImportScreenArgs._({this.filePath, this.text});

  const ImportScreenArgs.file(String path) : this._(filePath: path);

  const ImportScreenArgs.text(String content) : this._(text: content);

  final String? filePath;
  final String? text;
}
