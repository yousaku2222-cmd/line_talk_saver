import UIKit
import AVFoundation
import UniformTypeIdentifiers

// MARK: - Constants
//
// These match the keys used by the `receive_sharing_intent` Flutter plugin
// (see its ReceiveSharingIntentPlugin.swift) so the host app's Dart-side
// listener can read what this extension writes to the shared App Group
// container.
private let kSchemePrefix = "ShareMedia"
private let kUserDefaultsKey = "ShareKey"
private let kUserDefaultsMessageKey = "ShareMessageKey"
private let kAppGroupIdKey = "AppGroupId"

// MARK: - Shared data model
//
// Mirrors `receive_sharing_intent`'s SharedMediaFile/SharedMediaType exactly
// (field names and JSON encoding must match what the host app's Dart code
// expects to decode).

private enum SharedMediaType: String, Codable {
    case image
    case video
    case text
    case file
    case url

    var toUTTypeIdentifier: String {
        switch self {
        case .image: return UTType.image.identifier
        case .video: return UTType.movie.identifier
        case .text: return UTType.text.identifier
        case .file: return UTType.fileURL.identifier
        case .url: return UTType.url.identifier
        }
    }

    static var allCases: [SharedMediaType] { [.image, .video, .text, .file, .url] }
}

private class SharedMediaFile: Codable {
    var path: String
    var mimeType: String?
    var thumbnail: String?
    var duration: Double?
    var message: String?
    var type: SharedMediaType

    init(
        path: String,
        mimeType: String? = nil,
        thumbnail: String? = nil,
        duration: Double? = nil,
        message: String? = nil,
        type: SharedMediaType
    ) {
        self.path = path
        self.mimeType = mimeType
        self.thumbnail = thumbnail
        self.duration = duration
        self.message = message
        self.type = type
    }
}

/// Hosts the OS share-sheet UI when the user picks "トーク保存" while
/// sharing a chat .txt export from LINE. No custom UI is needed here --
/// the shared file/text is handed straight to the host app, which then
/// shows the normal import-preview screen (see ShareIntentListener).
///
/// NOTE: This is a self-contained reimplementation of
/// `receive_sharing_intent`'s RSIShareViewController, copied in directly
/// instead of imported from the plugin's Swift package. The plugin's own
/// Swift Package target bundles ALL of the app's Flutter plugins together
/// (via FlutterGeneratedPluginSwiftPackage), including google_mobile_ads --
/// linking that umbrella package into this lightweight extension pulled the
/// AdMob SDK in too, which is not supported inside app extensions and
/// caused the extension to crash / get killed at launch. Keeping this
/// extension's own source self-contained avoids linking any Flutter/plugin
/// code at all.
class ShareViewController: UIViewController {
    private var hostAppBundleIdentifier = ""
    private var appGroupId = ""
    private var sharedMedia: [SharedMediaFile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadIds()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .clear
        var ancestor = view.superview
        while let current = ancestor {
            current.backgroundColor = .clear
            current.isOpaque = false
            ancestor = current.superview
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let content = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = content.attachments,
              !attachments.isEmpty else {
            dismissWithError()
            return
        }

        // NOTE: `completeAttachment(index:content:)` must be called exactly once
        // per attachment no matter what happens (matched or not, cast succeeded
        // or not, error or not) -- it's the only thing that drives
        // saveAndRedirect() once the *last* attachment finishes. If any single
        // attachment silently falls through without it being called (e.g. a
        // multi-photo share where one item doesn't match any known type, or a
        // cast we didn't anticipate fails), the whole share hangs forever with
        // no error and no redirect, since nothing else drives completion. Every
        // branch below is careful to always reach it.
        for (index, attachment) in attachments.enumerated() {
            var matchedType: SharedMediaType?
            for type in SharedMediaType.allCases {
                if attachment.hasItemConformingToTypeIdentifier(type.toUTTypeIdentifier) {
                    matchedType = type
                    break
                }
            }

            guard let type = matchedType else {
                completeAttachment(index: index, content: content)
                continue
            }

            attachment.loadItem(forTypeIdentifier: type.toUTTypeIdentifier) { [weak self] data, error in
                guard let self else { return }
                guard error == nil else {
                    self.completeAttachment(index: index, content: content)
                    return
                }
                switch type {
                case .text:
                    // NOTE: LINE's "トークをテキストで送信" hands back the
                    // plain-text attachment as a file URL (NSURL) pointing
                    // to a temp file, not as a String/NSString directly --
                    // even though the type identifier is "public.text".
                    // Handle both shapes.
                    if let text = data as? String {
                        self.handleMedia(forLiteral: text, type: type, index: index, content: content)
                    } else if let nsText = data as? NSString {
                        self.handleMedia(forLiteral: nsText as String, type: type, index: index, content: content)
                    } else if let textData = data as? Data, let text = String(data: textData, encoding: .utf8) {
                        self.handleMedia(forLiteral: text, type: type, index: index, content: content)
                    } else if let url = data as? URL, let text = try? String(contentsOf: url, encoding: .utf8) {
                        self.handleMedia(forLiteral: text, type: type, index: index, content: content)
                    } else {
                        self.completeAttachment(index: index, content: content)
                    }
                case .url:
                    if let url = data as? URL {
                        self.handleMedia(forLiteral: url.absoluteString, type: type, index: index, content: content)
                    } else {
                        self.completeAttachment(index: index, content: content)
                    }
                default:
                    if let url = data as? URL {
                        self.handleMedia(forFile: url, type: type, index: index, content: content)
                    } else if let image = data as? UIImage {
                        self.handleMedia(forUIImage: image, type: type, index: index, content: content)
                    } else {
                        self.completeAttachment(index: index, content: content)
                    }
                }
            }
        }
    }

    private func loadIds() {
        let shareExtensionAppBundleIdentifier = Bundle.main.bundleIdentifier!
        let lastIndexOfPoint = shareExtensionAppBundleIdentifier.lastIndex(of: ".")
        hostAppBundleIdentifier = String(shareExtensionAppBundleIdentifier[..<lastIndexOfPoint!])
        let defaultAppGroupId = "group.\(hostAppBundleIdentifier)"
        let customAppGroupId = Bundle.main.object(forInfoDictionaryKey: kAppGroupIdKey) as? String
        appGroupId = customAppGroupId ?? defaultAppGroupId
    }

    private func handleMedia(forLiteral item: String, type: SharedMediaType, index: Int, content: NSExtensionItem) {
        sharedMedia.append(SharedMediaFile(path: item, mimeType: type == .text ? "text/plain" : nil, type: type))
        completeAttachment(index: index, content: content)
    }

    private func handleMedia(forUIImage image: UIImage, type: SharedMediaType, index: Int, content: NSExtensionItem) {
        let tempPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)!.appendingPathComponent("TempImage.png")
        if writeTempFile(image, to: tempPath) {
            let newPathDecoded = tempPath.absoluteString.removingPercentEncoding!
            sharedMedia.append(SharedMediaFile(path: newPathDecoded, mimeType: "image/png", type: type))
        }
        completeAttachment(index: index, content: content)
    }

    private func handleMedia(forFile url: URL, type: SharedMediaType, index: Int, content: NSExtensionItem) {
        let fileName = getFileName(from: url, type: type)
        let newPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)!.appendingPathComponent(fileName)

        if copyFile(at: url, to: newPath) {
            let newPathDecoded = newPath.absoluteString.removingPercentEncoding!
            if type == .video {
                if let videoInfo = getVideoInfo(from: url) {
                    let thumbnailPathDecoded = videoInfo.thumbnail?.removingPercentEncoding
                    sharedMedia.append(SharedMediaFile(
                        path: newPathDecoded,
                        mimeType: url.mimeType(),
                        thumbnail: thumbnailPathDecoded,
                        duration: videoInfo.duration,
                        type: type
                    ))
                }
            } else {
                sharedMedia.append(SharedMediaFile(path: newPathDecoded, mimeType: url.mimeType(), type: type))
            }
        }

        completeAttachment(index: index, content: content)
    }

    private func completeAttachment(index: Int, content: NSExtensionItem) {
        guard index == (content.attachments?.count ?? 0) - 1 else { return }
        saveAndRedirect()
    }

    private func saveAndRedirect(message: String? = nil) {
        let userDefaults = UserDefaults(suiteName: appGroupId)
        userDefaults?.set(toData(data: sharedMedia), forKey: kUserDefaultsKey)
        userDefaults?.set(message, forKey: kUserDefaultsMessageKey)
        userDefaults?.synchronize()
        redirectToHostApp()
    }

    private func redirectToHostApp() {
        loadIds()
        let url = URL(string: "\(kSchemePrefix)-\(hostAppBundleIdentifier):share")
        var responder = self as UIResponder?

        if #available(iOS 18.0, *) {
            while responder != nil {
                if let application = responder as? UIApplication {
                    application.open(url!, options: [:], completionHandler: nil)
                }
                responder = responder?.next
            }
        } else {
            let selectorOpenURL = sel_registerName("openURL:")
            while responder != nil {
                if responder?.responds(to: selectorOpenURL) == true {
                    _ = responder?.perform(selectorOpenURL, with: url)
                }
                responder = responder?.next
            }
        }

        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    private func dismissWithError() {
        print("[ERROR] Error loading data!")
        let alert = UIAlertController(title: "Error", message: "Error loading data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        })
        present(alert, animated: true, completion: nil)
    }

    private func getFileName(from url: URL, type: SharedMediaType) -> String {
        var name = url.lastPathComponent
        if name.isEmpty {
            switch type {
            case .image: name = UUID().uuidString + ".png"
            case .video: name = UUID().uuidString + ".mp4"
            case .text: name = UUID().uuidString + ".txt"
            default: name = UUID().uuidString
            }
        }
        return name
    }

    private func writeTempFile(_ image: UIImage, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try image.pngData()?.write(to: dstURL)
            return true
        } catch {
            print("Cannot write to temp file: \(error)")
            return false
        }
    }

    private func copyFile(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
            return true
        } catch {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
    }

    private func getVideoInfo(from url: URL) -> (thumbnail: String?, duration: Double)? {
        let asset = AVAsset(url: url)
        let duration = (CMTimeGetSeconds(asset.duration) * 1000).rounded()
        let thumbnailPath = getThumbnailPath(for: url)

        if FileManager.default.fileExists(atPath: thumbnailPath.path) {
            return (thumbnail: thumbnailPath.absoluteString, duration: duration)
        }

        var saved = false
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: 360, height: 360)
        do {
            let img = try assetImgGenerate.copyCGImage(at: CMTimeMakeWithSeconds(600, preferredTimescale: 1), actualTime: nil)
            try UIImage(cgImage: img).pngData()?.write(to: thumbnailPath)
            saved = true
        } catch {
            saved = false
        }

        return saved ? (thumbnail: thumbnailPath.absoluteString, duration: duration) : nil
    }

    private func getThumbnailPath(for url: URL) -> URL {
        let fileName = Data(url.lastPathComponent.utf8).base64EncodedString().replacingOccurrences(of: "==", with: "")
        return FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupId)!
            .appendingPathComponent("\(fileName).jpg")
    }

    private func toData(data: [SharedMediaFile]) -> Data {
        (try? JSONEncoder().encode(data)) ?? Data()
    }
}

private extension URL {
    func mimeType() -> String {
        if let mimeType = UTType(filenameExtension: pathExtension)?.preferredMIMEType {
            return mimeType
        }
        return "application/octet-stream"
    }
}
