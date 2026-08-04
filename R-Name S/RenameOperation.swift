import Foundation

enum LetterCase: String, CaseIterable, Sendable {
    case lowercase = "Lowercase"
    case uppercase = "Uppercase"
    case capitalized = "Capitalize Words"
}

enum RemoveEdge: String, CaseIterable, Sendable {
    case beginning = "Beginning"
    case end = "End"
}

enum RenameOperation: Sendable, Equatable {
    case findReplace(find: String, replacement: String, regularExpression: Bool, caseInsensitive: Bool, replaceAll: Bool, preserveExtension: Bool)
    case sequence(prefix: String, suffix: String, start: Int, step: Int, minimumDigits: Int, sameDigits: Bool, preserveExtension: Bool, replacementExtension: String?)
    case changeCase(LetterCase, preserveExtension: Bool)
    case addPrefix(String)
    case addSuffix(String)
    case addBeforeExtension(String)
    case removeFromEdge(RemoveEdge, count: Int, preserveExtension: Bool)
    case removeRange(start: Int, count: Int, fromEnd: Bool, preserveExtension: Bool)
    case addExtension(String)
    case replaceExtension(String)
    case removeExtension

    func renamed(_ original: String, sequenceIndex: Int = 0, sequenceCount: Int = 1) throws -> String {
        switch self {
        case let .findReplace(find, replacement, regex, insensitive, all, preserve):
            return try transformStem(of: original, preservingExtension: preserve) { value in
                if regex {
                    var options: NSRegularExpression.Options = []
                    if insensitive { options.insert(.caseInsensitive) }
                    let expression = try NSRegularExpression(pattern: find, options: options)
                    let range = NSRange(value.startIndex..., in: value)
                    if all {
                        return expression.stringByReplacingMatches(in: value, range: range, withTemplate: replacement)
                    }
                    guard let match = expression.firstMatch(in: value, range: range) else { return value }
                    return expression.stringByReplacingMatches(in: value, range: match.range, withTemplate: replacement)
                }
                guard !find.isEmpty else { return value }
                var options: String.CompareOptions = []
                if insensitive { options.insert(.caseInsensitive) }
                if all { return value.replacingOccurrences(of: find, with: replacement, options: options) }
                guard let range = value.range(of: find, options: options) else { return value }
                return value.replacingCharacters(in: range, with: replacement)
            }

        case let .sequence(prefix, suffix, start, step, minimumDigits, sameDigits, preserve, replacementExtension):
            let finalValue = start + max(0, sequenceCount - 1) * step
            let width = sameDigits ? max(minimumDigits, String(abs(finalValue)).count) : minimumDigits
            let value = start + sequenceIndex * step
            let sign = value < 0 ? "-" : ""
            let number = sign + String(format: "%0*d", width, abs(value))
            let ext = preserve ? splitName(original).extensionPart : normalizedExtension(replacementExtension ?? "")
            return join(stem: prefix + number + suffix, extensionPart: ext)

        case let .changeCase(letterCase, preserve):
            return transformStem(of: original, preservingExtension: preserve) { value in
                switch letterCase {
                case .lowercase: value.lowercased()
                case .uppercase: value.uppercased()
                case .capitalized: value.capitalized
                }
            }

        case let .addPrefix(value): return value + original
        case let .addSuffix(value): return original + value
        case let .addBeforeExtension(value):
            let parts = splitName(original)
            return join(stem: parts.stem + value, extensionPart: parts.extensionPart)

        case let .removeFromEdge(edge, count, preserve):
            return transformStem(of: original, preservingExtension: preserve) { value in
                let amount = min(max(count, 0), value.count)
                switch edge {
                case .beginning: return String(value.dropFirst(amount))
                case .end: return String(value.dropLast(amount))
                }
            }

        case let .removeRange(start, count, fromEnd, preserve):
            return transformStem(of: original, preservingExtension: preserve) { value in
                let safeCount = max(0, count)
                let origin = fromEnd ? max(0, value.count - max(0, start) - safeCount) : max(0, start)
                let lower = value.index(value.startIndex, offsetBy: min(origin, value.count))
                let upper = value.index(lower, offsetBy: min(safeCount, value.distance(from: lower, to: value.endIndex)))
                var result = value
                result.removeSubrange(lower..<upper)
                return result
            }

        case let .addExtension(value):
            let ext = normalizedExtension(value)
            return ext.isEmpty ? original : original + "." + ext
        case let .replaceExtension(value):
            let parts = splitName(original)
            return join(stem: parts.stem, extensionPart: normalizedExtension(value))
        case .removeExtension:
            return splitName(original).stem
        }
    }

    private func transformStem(of original: String, preservingExtension: Bool, _ body: (String) throws -> String) rethrows -> String {
        guard preservingExtension else { return try body(original) }
        let parts = splitName(original)
        return join(stem: try body(parts.stem), extensionPart: parts.extensionPart)
    }

    private func splitName(_ value: String) -> (stem: String, extensionPart: String) {
        let url = URL(fileURLWithPath: value)
        let ext = url.pathExtension
        guard !ext.isEmpty, !value.hasPrefix(".") else { return (value, "") }
        return (url.deletingPathExtension().lastPathComponent, ext)
    }

    private func normalizedExtension(_ value: String) -> String {
        String(value.drop(while: { $0 == "." }))
    }

    private func join(stem: String, extensionPart: String) -> String {
        extensionPart.isEmpty ? stem : stem + "." + extensionPart
    }
}
