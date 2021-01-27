import Foundation
import Logging

struct RonnieLogHandler: LogHandler {
    private let label: String

    private let dateFormatter: DateFormatter = {
        let res = DateFormatter()
        res.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return res
    }()

    #if DEBUG
        var logLevel: Logger.Level = .trace
    #else
        var logLevel: Logger.Level = .warning
    #endif

    static func create(label: String) -> RonnieLogHandler {
        RonnieLogHandler(label: label)
    }

    init(label: String) {
        self.label = label
    }

    // swiftlint:disable function_parameter_count
    func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        file _: String,
        function _: String,
        line _: UInt
    ) {
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))

        #if DEBUG
            // swiftlint:disable line_length
            print("\(timestamp()) \(level.colorEmoji) \(label): \(message) —\(prettyMetadata.map { " \($0)" } ?? " n/a")")
        // swiftlint:enable line_length
        #else
            // TODO: set up remote logging
        #endif
    }

    // swiftlint:enable function_parameter_count

    subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set {
            metadata[metadataKey] = newValue
        }
    }

    private var prettyMetadata: String?
    var metadata = Logger.Metadata() {
        didSet {
            prettyMetadata = prettify(metadata)
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }

    private func timestamp() -> String {
        dateFormatter.string(from: Date())
    }
}

extension Logger.Level {
    var colorEmoji: String {
        switch self {
        case .trace:
            return "⬜️"
        case .debug:
            return "🟦"
        case .info:
            return "🟩"
        case .notice:
            return "🟨"
        case .warning:
            return "🟧"
        case .error:
            return "🟥"
        case .critical:
            return "⬛️"
        }
    }
}
