/// Arguments carried through the routes involved in attaching one or more
/// photos/videos that were shared into the app from another app (e.g. LINE
/// multi-select share) rather than picked via the in-app gallery button.
class PendingPhotoArgs {
  const PendingPhotoArgs(this.localFilePaths);

  /// Already persisted under the app's own `photos/` directory -- see
  /// `persistPhotoFile`. Always non-empty.
  final List<String> localFilePaths;
}
