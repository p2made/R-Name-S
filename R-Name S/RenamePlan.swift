import Foundation

struct RenameItem: Identifiable, Sendable, Equatable {
    let id: UUID
    let source: URL
    var destinationName: String
    var isEnabled: Bool

    init(id: UUID = UUID(), source: URL, destinationName: String? = nil, isEnabled: Bool = true) {
        self.id = id
        self.source = source
        self.destinationName = destinationName ?? source.lastPathComponent
        self.isEnabled = isEnabled
    }

    var destination: URL { source.deletingLastPathComponent().appendingPathComponent(destinationName) }
}

enum RenameIssue: Error, LocalizedError, Equatable {
    case emptyName(String)
    case hiddenName(String)
    case invalidName(String)
    case nameTooLong(String)
    case duplicateDestination(String)
    case destinationExists(String)

    var errorDescription: String? {
        switch self {
        case let .emptyName(source): "The new name for “\(source)” is empty."
        case let .hiddenName(name): "“\(name)” begins with a period and would become hidden."
        case let .invalidName(name): "“\(name)” contains an invalid slash or NUL character."
        case let .nameTooLong(name): "“\(name)” is longer than the filesystem limit of 255 characters."
        case let .duplicateDestination(name): "More than one item would be renamed to “\(name)”."
        case let .destinationExists(name): "An unrelated item already exists at “\(name)”."
        }
    }
}

enum RenamePlanner {
    static func validate(_ items: [RenameItem], fileManager: FileManager = .default) -> [RenameIssue] {
        let active = items.filter { $0.isEnabled && $0.source.lastPathComponent != $0.destinationName }
        let sourceKeys = Set(active.map { normalized($0.source) })
        var seen = Set<String>()
        var issues: [RenameIssue] = []

        for item in active {
            let name = item.destinationName
            if name.isEmpty { issues.append(.emptyName(item.source.lastPathComponent)); continue }
            if name.hasPrefix(".") { issues.append(.hiddenName(name)) }
            if name.contains("/") || name.contains("\0") { issues.append(.invalidName(name)) }
            if name.utf16.count > 255 { issues.append(.nameTooLong(name)) }
            let key = normalized(item.destination)
            if !seen.insert(key).inserted { issues.append(.duplicateDestination(name)) }
            if fileManager.fileExists(atPath: item.destination.path), !sourceKeys.contains(key), normalized(item.source) != key {
                issues.append(.destinationExists(name))
            }
        }
        return issues
    }

    static func execute(_ items: [RenameItem], fileManager: FileManager = .default) throws {
        let active = items.filter { $0.isEnabled && $0.source.lastPathComponent != $0.destinationName }
        if let issue = validate(active, fileManager: fileManager).first { throw issue }

        var staged: [(original: URL, temporary: URL, destination: URL)] = []
        var committed = 0
        do {
            for item in active {
                let temporary = item.source.deletingLastPathComponent()
                    .appendingPathComponent(".rname-\(UUID().uuidString)-\(item.source.lastPathComponent)")
                try fileManager.moveItem(at: item.source, to: temporary)
                staged.append((item.source, temporary, item.destination))
            }
            for pair in staged {
                try fileManager.moveItem(at: pair.temporary, to: pair.destination)
                committed += 1
            }
        } catch {
            for pair in staged.prefix(committed).reversed() where fileManager.fileExists(atPath: pair.destination.path) {
                try? fileManager.moveItem(at: pair.destination, to: pair.original)
            }
            for pair in staged.dropFirst(committed).reversed() where fileManager.fileExists(atPath: pair.temporary.path) {
                try? fileManager.moveItem(at: pair.temporary, to: pair.original)
            }
            throw error
        }
    }

    private static func normalized(_ url: URL) -> String {
        url.standardizedFileURL.path.precomposedStringWithCanonicalMapping.lowercased()
    }
}
