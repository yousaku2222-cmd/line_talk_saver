import receive_sharing_intent

/// Hosts the OS share-sheet UI when the user picks "LINEトーク保存" while
/// sharing a chat .txt export from LINE. No custom UI is needed here --
/// the shared file/text is handed straight to the host app, which then
/// shows the normal import-preview screen (see ShareIntentListener).
class ShareViewController: RSIShareViewController {
    override func shouldAutoRedirect() -> Bool {
        return true
    }
}
