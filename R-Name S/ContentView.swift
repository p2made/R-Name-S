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
            .windowResizability(.contentMinSize)
            .commands {
                CommandGroup(after: .newItem) {
                    Button("Add Files or Folders…") { model.chooseFiles() }
                        .keyboardShortcut("o")
                }
            }
        Settings { SettingsView().environmentObject(model) }
    }
}

enum OperationKind: String, CaseIterable, Identifiable {
    case findReplace = "Find and Replace"
    case sequence = "Number Sequentially"
    case changeCase = "Change Case"
    case prefixSuffix = "Add Characters"
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
    @Published var kind: OperationKind = .findReplace { didSet { invalidatePreview() } }
    @Published var status = "Drop files here or click Add…"
    @Published var includeFiles = true
    @Published var includeFolderContents = false
    @Published var includeFolders = false
    @Published var sortOrder: SortOrder = .none { didSet { sortItems() } }
    @Published private(set) var hasPreview = false
    @Published private(set) var previewIsValid = false
    @Published private(set) var progress = 0.0

    @Published var find = "" { didSet { invalidatePreview() } }
    @Published var replacement = "" { didSet { invalidatePreview() } }
    @Published var useRegex = false { didSet { invalidatePreview() } }
    @Published var caseInsensitive = false { didSet { invalidatePreview() } }
    @Published var replaceAll = true { didSet { invalidatePreview() } }
    @Published var preserveExtension = true { didSet { invalidatePreview() } }

    @Published var prefix = "" { didSet { invalidatePreview() } }
    @Published var suffix = "" { didSet { invalidatePreview() } }
    @Published var start = 1 { didSet { invalidatePreview() } }
    @Published var step = 1 { didSet { invalidatePreview() } }
    @Published var digits = 1 { didSet { invalidatePreview() } }
    @Published var sameDigits = false { didSet { invalidatePreview() } }

    @Published var letterCase: LetterCase = .lowercase { didSet { invalidatePreview() } }
    @Published var addPosition = 0 { didSet { invalidatePreview() } }
    @Published var textToAdd = "" { didSet { invalidatePreview() } }
    @Published var removeEdge: RemoveEdge = .beginning { didSet { invalidatePreview() } }
    @Published var removeCount = 1 { didSet { invalidatePreview() } }
    @Published var removeMode = 0 { didSet { invalidatePreview() } }
    @Published var rangeStart = 0 { didSet { invalidatePreview() } }
    @Published var rangeCount = 1 { didSet { invalidatePreview() } }
    @Published var rangeFromEnd = false { didSet { invalidatePreview() } }
    @Published var extensionMode = 0 { didSet { invalidatePreview() } }
    @Published var extensionText = "" { didSet { invalidatePreview() } }

    var issues: [RenameIssue] { RenamePlanner.validate(items) }
    var enabledChangeCount: Int { items.filter { $0.isEnabled && $0.source.lastPathComponent != $0.destinationName }.count }
    var canRename: Bool { previewIsValid && enabledChangeCount > 0 && issues.isEmpty }

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
                        if includeFiles && !directory { discovered.append(child) }
                    }
                }
            } else if (!isDirectory.boolValue && includeFiles) || (isDirectory.boolValue && includeFolders) {
                discovered.append(url)
            }
        }
        let existing = Set(items.map { $0.source.standardizedFileURL })
        items.append(contentsOf: discovered.filter { !existing.contains($0.standardizedFileURL) }.map { RenameItem(source: $0) })
        sortItems()
    }

    func invalidatePreview() {
        hasPreview = false
        previewIsValid = false
        progress = 0
        for index in items.indices {
            items[index].destinationName = items[index].source.lastPathComponent
        }
        status = items.isEmpty
            ? "Drop files here or choose File > Add Files or Folders…"
            : "\(items.count) item\(items.count == 1 ? "" : "s") awaiting preview"
    }

    func showNewNames() {
        guard !items.isEmpty else {
            invalidatePreview()
            return
        }

        let operation = currentOperation
        let count = items.count
        var proposed = items
        for index in items.indices {
            do {
                proposed[index].destinationName = try operation.renamed(items[index].source.lastPathComponent, sequenceIndex: index, sequenceCount: count)
            } catch {
                hasPreview = false
                previewIsValid = false
                status = error.localizedDescription
                NSSound.beep()
                return
            }
        }

        items = proposed
        hasPreview = true
        if let issue = issues.first {
            previewIsValid = false
            status = issue.localizedDescription
            NSSound.beep()
        } else {
            previewIsValid = true
            status = "\(enabledChangeCount) item\(enabledChangeCount == 1 ? "" : "s") ready to rename"
        }
    }

    func clearItems() {
        items.removeAll()
        invalidatePreview()
    }

    func rename() {
        guard canRename else { return }
        do {
            try RenamePlanner.execute(items)
            let renamedCount = enabledChangeCount
            items = items.map { item in
                guard item.isEnabled else { return item }
                return RenameItem(id: item.id, source: item.destination, isEnabled: item.isEnabled)
            }
            hasPreview = false
            previewIsValid = false
            progress = 1
            for index in items.indices {
                items[index].destinationName = items[index].source.lastPathComponent
            }
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
        invalidatePreview()
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
    private let controlsHeight: CGFloat = 360
    private let actionColumnWidth: CGFloat = 230

    var body: some View {
        VStack(spacing: 14) {
            HStack(alignment: .top, spacing: 18) {
                VStack(spacing: 10) {
                    Picker("Rename operation", selection: $model.kind) {
                        ForEach(OperationKind.allCases) { operation in
                            Text(operation.rawValue).tag(operation)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)

                    GroupBox("Settings") {
                        OperationEditor()
                            .padding(.top, 4)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                ActionColumn()
                    .frame(width: actionColumnWidth, height: controlsHeight)
            }
            .frame(height: controlsHeight)

            RenameItemsTable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(18)
        .frame(minWidth: 820, minHeight: 580)
        .background(WindowFrameAutosave(name: "RNameSMainWindow"))
        .dropDestination(for: URL.self) { urls, _ in
            model.add(urls: urls)
            return true
        }
    }
}

struct ActionColumn: View {
    @EnvironmentObject private var model: RenameViewModel

    var body: some View {
        VStack(spacing: 12) {
            GroupBox("Add to List") {
                VStack(alignment: .leading, spacing: 9) {
                    Toggle("Files", isOn: $model.includeFiles)
                    Toggle("Folders", isOn: $model.includeFolders)
                    Toggle("Recurse Folder", isOn: $model.includeFolderContents)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 2)
            }

            Spacer(minLength: 12)

            Button("Show New Names") { model.showNewNames() }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity)
                .disabled(model.items.isEmpty)

            Button("Clear List") { model.clearItems() }
                .controlSize(.large)
                .frame(maxWidth: .infinity)
                .disabled(model.items.isEmpty)

            Button("Rename Now") { model.rename() }
                .controlSize(.large)
                .frame(maxWidth: .infinity)
                .keyboardShortcut(.return, modifiers: [.command])
                .disabled(!model.canRename)

            Spacer(minLength: 4)

            Text(model.status)
                .font(.caption)
                .foregroundStyle(model.previewIsValid || model.items.isEmpty ? .secondary : .primary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            ProgressView(value: model.progress, total: 1)
                .progressViewStyle(.linear)
        }
    }
}

struct RenameItemsTable: View {
    @EnvironmentObject private var model: RenameViewModel

    var body: some View {
        Table($model.items) {
            TableColumn("") { $item in
                HStack(spacing: 6) {
                    Toggle("", isOn: $item.isEnabled)
                        .labelsHidden()
                    Text(rowNumber(for: item))
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
            }
            .width(min: 58, ideal: 58, max: 58)

            TableColumn("Old") { $item in
                Text(item.source.path)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            TableColumn("New") { $item in
                Text(model.hasPreview ? item.destination.path : "")
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .foregroundStyle(item.destinationName == item.source.lastPathComponent ? .secondary : .primary)
            }
        }
        .tableStyle(.inset(alternatesRowBackgrounds: true))
        .overlay {
            if model.items.isEmpty {
                ContentUnavailableView(
                    "Add files to begin",
                    systemImage: "arrow.down.doc",
                    description: Text("Drop files or folders into this window, or press ⌘O")
                )
            }
        }
    }

    private func rowNumber(for item: RenameItem) -> String {
        guard let index = model.items.firstIndex(where: { $0.id == item.id }) else { return "" }
        return String(index + 1)
    }
}

struct OperationEditor: View {
    @EnvironmentObject private var model: RenameViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            switch model.kind {
            case .findReplace:
                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                    GridRow {
                        FormLabel("Find:")
                        TextField("", text: $model.find)
                    }
                    GridRow {
                        FormLabel("Replace:")
                        TextField("", text: $model.replacement)
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Case insensitive", isOn: $model.caseInsensitive)
                    Toggle("Replace all found in filename", isOn: $model.replaceAll)
                    PreserveExtensionToggle()
                    Toggle("Regular expression", isOn: $model.useRegex)
                }
                .padding(.leading, 105)

            case .sequence:
                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                    GridRow { FormLabel("Prefix:"); TextField("", text: $model.prefix) }
                    GridRow { FormLabel("Suffix:"); TextField("", text: $model.suffix) }
                    GridRow {
                        FormLabel("Numbers:")
                        HStack(spacing: 16) {
                            Stepper("First: \(model.start)", value: $model.start)
                            Stepper("Step: \(model.step)", value: $model.step)
                            Stepper("Digits: \(model.digits)", value: $model.digits, in: 1...12)
                        }
                    }
                    GridRow {
                        FormLabel("Sort:")
                        Picker("", selection: $model.sortOrder) {
                            ForEach(SortOrder.allCases) { Text($0.rawValue).tag($0) }
                        }
                        .labelsHidden()
                    }
                }
                HStack(spacing: 18) {
                    Toggle("Same digits", isOn: $model.sameDigits)
                    PreserveExtensionToggle()
                    if !model.preserveExtension {
                        TextField("Extension", text: $model.extensionText).frame(maxWidth: 180)
                    }
                }
                .padding(.leading, 105)

            case .changeCase:
                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 12) {
                    GridRow {
                        FormLabel("Change to:")
                        Picker("", selection: $model.letterCase) {
                            ForEach(LetterCase.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .labelsHidden()
                    }
                    GridRow { Color.clear.frame(width: 95, height: 1); PreserveExtensionToggle() }
                }

            case .prefixSuffix:
                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 12) {
                    GridRow {
                        FormLabel("Position:")
                        Picker("", selection: $model.addPosition) {
                            Text("Beginning").tag(0)
                            Text("End").tag(1)
                            Text("Before Extension").tag(2)
                        }
                        .labelsHidden()
                    }
                    GridRow { FormLabel("Characters:"); TextField("", text: $model.textToAdd) }
                }

            case .removeEdge:
                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 12) {
                    GridRow {
                        FormLabel("Mode:")
                        Picker("", selection: $model.removeMode) {
                            Text("From Edge").tag(0)
                            Text("At Range").tag(1)
                        }
                        .labelsHidden()
                    }
                    if model.removeMode == 0 {
                        GridRow {
                            FormLabel("Remove:")
                            HStack(spacing: 16) {
                                Picker("", selection: $model.removeEdge) {
                                    ForEach(RemoveEdge.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                                }
                                .labelsHidden()
                                Stepper("Characters: \(model.removeCount)", value: $model.removeCount, in: 0...999)
                            }
                        }
                    } else {
                        GridRow {
                            FormLabel("Range:")
                            HStack(spacing: 16) {
                                Stepper("Start: \(model.rangeStart)", value: $model.rangeStart, in: 0...999)
                                Stepper("Count: \(model.rangeCount)", value: $model.rangeCount, in: 0...999)
                                Toggle("From end", isOn: $model.rangeFromEnd)
                            }
                        }
                    }
                    GridRow { Color.clear.frame(width: 95, height: 1); PreserveExtensionToggle() }
                }

            case .extensionChange:
                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 12) {
                    GridRow {
                        FormLabel("Action:")
                        Picker("", selection: $model.extensionMode) {
                            Text("Add").tag(0)
                            Text("Replace").tag(1)
                            Text("Remove").tag(2)
                        }
                        .labelsHidden()
                    }
                    if model.extensionMode != 2 {
                        GridRow { FormLabel("Extension:"); TextField("", text: $model.extensionText) }
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .textFieldStyle(.roundedBorder)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct FormLabel: View {
    let title: String

    init(_ title: String) { self.title = title }

    var body: some View {
        Text(title)
            .frame(width: 95, alignment: .trailing)
    }
}

struct PreserveExtensionToggle: View {
    @EnvironmentObject private var model: RenameViewModel
    var body: some View { Toggle("Preserve extension", isOn: $model.preserveExtension) }
}

struct WindowFrameAutosave: NSViewRepresentable {
    let name: String

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        configure(windowFor: view)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        configure(windowFor: nsView)
    }

    private func configure(windowFor view: NSView) {
        DispatchQueue.main.async {
            view.window?.setFrameAutosaveName(name)
        }
    }
}

/*
 The settings scene remains deliberately small; these choices control which
 paths are admitted to the main list rather than the three-zone window layout.
 */
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
