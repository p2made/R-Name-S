import SwiftUI
import AppKit
import Combine
import UniformTypeIdentifiers

@main
struct RNameSApp: App {
    @StateObject private var model = RenameViewModel()

    var body: some Scene {
        WindowGroup("R-Name S") { ContentView().environmentObject(model) }
            .defaultSize(width: 980, height: 650)
        Settings { SettingsView().environmentObject(model) }
    }
}

enum OperationKind: String, CaseIterable, Identifiable {
    case findReplace = "Find & Replace"
    case sequence = "Sequential Number"
    case changeCase = "Change Case"
    case prefixSuffix = "Add Text"
    case removeEdge = "Remove Characters"
    case extensionChange = "Change Extension"
    var id: String { rawValue }
}

enum SortOrder: String, CaseIterable, Identifiable {
    case none = "No Sort"
    case nameAZCaseSensitive = "Name A–Z (Case Sensitive)"
    case nameAZ = "Name A–Z"
    case nameZACaseSensitive = "Name Z–A (Case Sensitive)"
    case nameZA = "Name Z–A"
    case smallestFirst = "Smallest Size First"
    case largestFirst = "Largest Size First"
    case oldestModifiedFirst = "Oldest Modified First"
    case newestModifiedFirst = "Newest Modified First"
    case oldestCreatedFirst = "Oldest Created First"
    case newestCreatedFirst = "Newest Created First"

    var id: String { rawValue }
}

@MainActor
final class RenameViewModel: ObservableObject {
    @Published var items: [RenameItem] = []
    @Published var kind: OperationKind = .findReplace { didSet { refreshPreview() } }
    @Published var status = "Drop files here or click Add…"
    @Published var includeFolderContents = false
    @Published var includeFolders = false
    @Published var sortOrder: SortOrder = .none { didSet { sortItems() } }

    @Published var find = "" { didSet { refreshPreview() } }
    @Published var replacement = "" { didSet { refreshPreview() } }
    @Published var useRegex = false { didSet { refreshPreview() } }
    @Published var caseInsensitive = false { didSet { refreshPreview() } }
    @Published var replaceAll = true { didSet { refreshPreview() } }
    @Published var preserveExtension = true { didSet { refreshPreview() } }

    @Published var prefix = "" { didSet { refreshPreview() } }
    @Published var suffix = "" { didSet { refreshPreview() } }
    @Published var start = 1 { didSet { refreshPreview() } }
    @Published var step = 1 { didSet { refreshPreview() } }
    @Published var digits = 1 { didSet { refreshPreview() } }
    @Published var sameDigits = false { didSet { refreshPreview() } }

    @Published var letterCase: LetterCase = .lowercase { didSet { refreshPreview() } }
    @Published var addPosition = 0 { didSet { refreshPreview() } }
    @Published var textToAdd = "" { didSet { refreshPreview() } }
    @Published var removeEdge: RemoveEdge = .beginning { didSet { refreshPreview() } }
    @Published var removeCount = 1 { didSet { refreshPreview() } }
    @Published var removeMode = 0 { didSet { refreshPreview() } }
    @Published var rangeStart = 0 { didSet { refreshPreview() } }
    @Published var rangeCount = 1 { didSet { refreshPreview() } }
    @Published var rangeFromEnd = false { didSet { refreshPreview() } }
    @Published var extensionMode = 0 { didSet { refreshPreview() } }
    @Published var extensionText = "" { didSet { refreshPreview() } }

    var issues: [RenameIssue] { RenamePlanner.validate(items) }
    var enabledChangeCount: Int { items.filter { $0.isEnabled && $0.source.lastPathComponent != $0.destinationName }.count }

    func chooseFiles() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.canCreateDirectories = false
        if panel.runModal() == .OK { add(urls: panel.urls) }
    }

    func add(urls: [URL]) {
        var discovered: [URL] = []
        let fm = FileManager.default
        for url in urls {
            var isDirectory: ObjCBool = false
            guard fm.fileExists(atPath: url.path, isDirectory: &isDirectory) else { continue }
            if isDirectory.boolValue && includeFolderContents {
                if let enumerator = fm.enumerator(at: url, includingPropertiesForKeys: [.isDirectoryKey, .isHiddenKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
                    for case let child as URL in enumerator {
                        let directory = (try? child.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
                        if !directory { discovered.append(child) }
                    }
                }
            } else if !isDirectory.boolValue || includeFolders {
                discovered.append(url)
            }
        }
        let existing = Set(items.map { $0.source.standardizedFileURL })
        items.append(contentsOf: discovered.filter { !existing.contains($0.standardizedFileURL) }.map { RenameItem(source: $0) })
        sortItems()
    }

    func refreshPreview() {
        let operation = currentOperation
        let count = items.count
        for index in items.indices {
            do {
                items[index].destinationName = try operation.renamed(items[index].source.lastPathComponent, sequenceIndex: index, sequenceCount: count)
            } catch {
                items[index].destinationName = items[index].source.lastPathComponent
                status = error.localizedDescription
            }
        }
        if let issue = issues.first { status = issue.localizedDescription }
        else if items.isEmpty { status = "Drop files here or click Add…" }
        else { status = "\(enabledChangeCount) item\(enabledChangeCount == 1 ? "" : "s") ready to rename" }
    }

    func rename() {
        do {
            try RenamePlanner.execute(items)
            let renamedCount = enabledChangeCount
            items = items.map { item in
                guard item.isEnabled else { return item }
                return RenameItem(id: item.id, source: item.destination, isEnabled: item.isEnabled)
            }
            refreshPreview()
            status = "Renamed \(renamedCount) item\(renamedCount == 1 ? "" : "s")."
        } catch {
            status = error.localizedDescription
            NSSound.beep()
        }
    }

    private func sortItems() {
        let fm = FileManager.default
        let attributes: (RenameItem) -> [FileAttributeKey: Any] = {
            (try? fm.attributesOfItem(atPath: $0.source.path)) ?? [:]
        }

        switch sortOrder {
        case .none:
            break
        case .nameAZCaseSensitive:
            items.sort { $0.source.lastPathComponent.compare($1.source.lastPathComponent) == .orderedAscending }
        case .nameAZ:
            items.sort { $0.source.lastPathComponent.localizedCaseInsensitiveCompare($1.source.lastPathComponent) == .orderedAscending }
        case .nameZACaseSensitive:
            items.sort { $0.source.lastPathComponent.compare($1.source.lastPathComponent) == .orderedDescending }
        case .nameZA:
            items.sort { $0.source.lastPathComponent.localizedCaseInsensitiveCompare($1.source.lastPathComponent) == .orderedDescending }
        case .smallestFirst, .largestFirst:
            let ascending = sortOrder == .smallestFirst
            items.sort {
                let left = (attributes($0)[.size] as? NSNumber)?.int64Value ?? 0
                let right = (attributes($1)[.size] as? NSNumber)?.int64Value ?? 0
                return ascending ? left < right : left > right
            }
        case .oldestModifiedFirst, .newestModifiedFirst:
            let ascending = sortOrder == .oldestModifiedFirst
            items.sort {
                let left = attributes($0)[.modificationDate] as? Date ?? .distantPast
                let right = attributes($1)[.modificationDate] as? Date ?? .distantPast
                return ascending ? left < right : left > right
            }
        case .oldestCreatedFirst, .newestCreatedFirst:
            let ascending = sortOrder == .oldestCreatedFirst
            items.sort {
                let left = attributes($0)[.creationDate] as? Date ?? .distantPast
                let right = attributes($1)[.creationDate] as? Date ?? .distantPast
                return ascending ? left < right : left > right
            }
        }
        refreshPreview()
    }

    private var currentOperation: RenameOperation {
        switch kind {
        case .findReplace:
            return .findReplace(find: find, replacement: replacement, regularExpression: useRegex, caseInsensitive: caseInsensitive, replaceAll: replaceAll, preserveExtension: preserveExtension)
        case .sequence:
            return .sequence(prefix: prefix, suffix: suffix, start: start, step: step, minimumDigits: max(1, digits), sameDigits: sameDigits, preserveExtension: preserveExtension, replacementExtension: extensionText)
        case .changeCase: return .changeCase(letterCase, preserveExtension: preserveExtension)
        case .prefixSuffix:
            return addPosition == 0 ? .addPrefix(textToAdd) : addPosition == 1 ? .addSuffix(textToAdd) : .addBeforeExtension(textToAdd)
        case .removeEdge:
            return removeMode == 0
                ? .removeFromEdge(removeEdge, count: removeCount, preserveExtension: preserveExtension)
                : .removeRange(start: rangeStart, count: rangeCount, fromEnd: rangeFromEnd, preserveExtension: preserveExtension)
        case .extensionChange:
            return extensionMode == 0 ? .addExtension(extensionText) : extensionMode == 1 ? .replaceExtension(extensionText) : .removeExtension
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var model: RenameViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Picker("Method", selection: $model.kind) {
                    ForEach(OperationKind.allCases) { Text($0.rawValue).tag($0) }
                }.frame(width: 300)
                Spacer()
                Menu {
                    Picker("Sort", selection: $model.sortOrder) {
                        ForEach(SortOrder.allCases) { Text($0.rawValue).tag($0) }
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
                Button("Add…") { model.chooseFiles() }.keyboardShortcut("o")
                Button("Clear") { model.items.removeAll(); model.refreshPreview() }.disabled(model.items.isEmpty)
                Button("Rename") { model.rename() }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.return, modifiers: [.command])
                    .disabled(model.enabledChangeCount == 0 || !model.issues.isEmpty)
            }.padding()

            Divider()
            OperationEditor().padding()
            Divider()

            Table($model.items) {
                TableColumn("Use") { $item in Toggle("", isOn: $item.isEnabled).labelsHidden() }.width(40)
                TableColumn("Current Name") { $item in Text(item.source.lastPathComponent).lineLimit(1) }
                TableColumn("New Name") { $item in
                    Text(item.destinationName)
                        .foregroundStyle(item.destinationName == item.source.lastPathComponent ? .secondary : .primary)
                        .lineLimit(1)
                }
                TableColumn("Folder") { $item in Text(item.source.deletingLastPathComponent().path).foregroundStyle(.secondary).lineLimit(1) }
            }
            .overlay {
                if model.items.isEmpty {
                    ContentUnavailableView("Add files to begin", systemImage: "arrow.down.doc", description: Text("Drop files into this window or use Add…"))
                }
            }
            .dropDestination(for: URL.self) { urls, _ in model.add(urls: urls); return true }

            Divider()
            HStack {
                Image(systemName: model.issues.isEmpty ? "checkmark.circle" : "exclamationmark.triangle.fill")
                    .foregroundStyle(model.issues.isEmpty ? Color.secondary : Color.orange)
                Text(model.status).lineLimit(1)
                Spacer()
                Text("\(model.items.count) total").foregroundStyle(.secondary)
            }.padding(10)
        }
        .frame(minWidth: 760, minHeight: 500)
    }
}

struct OperationEditor: View {
    @EnvironmentObject private var model: RenameViewModel

    var body: some View {
        Group {
            switch model.kind {
            case .findReplace:
                HStack {
                    TextField("Find", text: $model.find)
                    Image(systemName: "arrow.right")
                    TextField("Replace with", text: $model.replacement)
                    Toggle("Regex", isOn: $model.useRegex)
                    Toggle("Ignore case", isOn: $model.caseInsensitive)
                    Toggle("All", isOn: $model.replaceAll)
                    PreserveExtensionToggle()
                }
            case .sequence:
                HStack {
                    TextField("Prefix", text: $model.prefix)
                    TextField("Suffix", text: $model.suffix)
                    Stepper("Start: \(model.start)", value: $model.start)
                    Stepper("Step: \(model.step)", value: $model.step)
                    Stepper("Digits: \(model.digits)", value: $model.digits, in: 1...12)
                    Toggle("Same digits", isOn: $model.sameDigits)
                    PreserveExtensionToggle()
                    if !model.preserveExtension {
                        TextField("Extension", text: $model.extensionText).frame(width: 110)
                    }
                }
            case .changeCase:
                HStack {
                    Picker("Case", selection: $model.letterCase) { ForEach(LetterCase.allCases, id: \.self) { Text($0.rawValue).tag($0) } }
                    PreserveExtensionToggle()
                    Spacer()
                }
            case .prefixSuffix:
                HStack {
                    Picker("Position", selection: $model.addPosition) {
                        Text("Beginning").tag(0); Text("End").tag(1); Text("Before Extension").tag(2)
                    }
                    TextField("Text to add", text: $model.textToAdd)
                }
            case .removeEdge:
                HStack {
                    Picker("Mode", selection: $model.removeMode) {
                        Text("From Edge").tag(0)
                        Text("At Range").tag(1)
                    }
                    if model.removeMode == 0 {
                        Picker("From", selection: $model.removeEdge) { ForEach(RemoveEdge.allCases, id: \.self) { Text($0.rawValue).tag($0) } }
                        Stepper("Characters: \(model.removeCount)", value: $model.removeCount, in: 0...999)
                    } else {
                        Stepper("Start: \(model.rangeStart)", value: $model.rangeStart, in: 0...999)
                        Stepper("Count: \(model.rangeCount)", value: $model.rangeCount, in: 0...999)
                        Toggle("Count from end", isOn: $model.rangeFromEnd)
                    }
                    PreserveExtensionToggle()
                    Spacer()
                }
            case .extensionChange:
                HStack {
                    Picker("Action", selection: $model.extensionMode) {
                        Text("Add").tag(0); Text("Replace").tag(1); Text("Remove").tag(2)
                    }
                    if model.extensionMode != 2 { TextField("Extension", text: $model.extensionText).frame(width: 180) }
                    Spacer()
                }
            }
        }
        .textFieldStyle(.roundedBorder)
    }
}

struct PreserveExtensionToggle: View {
    @EnvironmentObject private var model: RenameViewModel
    var body: some View { Toggle("Preserve extension", isOn: $model.preserveExtension) }
}

struct SettingsView: View {
    @EnvironmentObject private var model: RenameViewModel
    var body: some View {
        Form {
            Toggle("Include folder contents", isOn: $model.includeFolderContents)
            Toggle("Allow folders as rename items", isOn: $model.includeFolders)
            Text("When including folder contents, only files are added so parent and child paths are never renamed in the same operation.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }.padding().frame(width: 360)
    }
}
