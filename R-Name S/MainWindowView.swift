import SwiftUI

/// Measurements for the initial 600 × 435 point content area.
///
/// SwiftUI lays out macOS interfaces in points. At 72 ppi, one point is one
/// pixel; Retina displays add pixels without changing these measurements.
enum MainWindowMetrics {
    static let initialWidth: CGFloat = 600
    static let initialHeight: CGFloat = 435
    static let upperHeight: CGFloat = 270
    static let operationMinimumWidth: CGFloat = 435
    static let sourceAndActionsWidth: CGFloat = 165
    static let listMinimumHeight: CGFloat = 164
}

/// Composes the three regions but contains no region-specific controls.
struct ContentView: View {
    @EnvironmentObject private var model: RenameViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                OperationPanelView()
                    .frame(
                        minWidth: MainWindowMetrics.operationMinimumWidth,
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )

                SourceAndActionsView()
                    .frame(width: MainWindowMetrics.sourceAndActionsWidth)
            }
            .frame(height: MainWindowMetrics.upperHeight)

            Divider()

            RenameItemsTable()
                .frame(
                    maxWidth: .infinity,
                    minHeight: MainWindowMetrics.listMinimumHeight,
                    maxHeight: .infinity
                )
        }
        .frame(
            minWidth: MainWindowMetrics.initialWidth,
            minHeight: MainWindowMetrics.initialHeight
        )
        .background(WindowFrameAutosave(name: "RNameSMainWindow"))
        .dropDestination(for: URL.self) { urls, _ in
            model.add(urls: urls)
            return true
        }
    }
}

/// Operation selection is a separate view with a binding, so the same state
/// can later be exposed by a menu-bar command without duplicating it.
struct OperationSelectionView: View {
    @Binding var selection: OperationKind

    var body: some View {
        Picker("Rename operation", selection: $selection) {
            ForEach(OperationKind.allCases) { operation in
                Text(operation.rawValue).tag(operation)
            }
        }
        .labelsHidden()
        .pickerStyle(.menu)
        .frame(maxWidth: .infinity)
    }
}

struct OperationPanelView: View {
    @EnvironmentObject private var model: RenameViewModel

    var body: some View {
        VStack(spacing: 7) {
            OperationSelectionView(selection: $model.kind)

            GroupBox("Settings") {
                OperationEditor()
                    .padding(.top, 2)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(8)
    }
}

#Preview("Main Window") {
    ContentView()
        .environmentObject(RenameViewModel())
        .frame(
            width: MainWindowMetrics.initialWidth,
            height: MainWindowMetrics.initialHeight
        )
}

#Preview("Operation Region") {
    OperationPanelView()
        .environmentObject(RenameViewModel())
        .frame(
            width: MainWindowMetrics.operationMinimumWidth,
            height: MainWindowMetrics.upperHeight
        )
}

#Preview("Input and Actions Region") {
    SourceAndActionsView()
        .environmentObject(RenameViewModel())
        .frame(
            width: MainWindowMetrics.sourceAndActionsWidth,
            height: MainWindowMetrics.upperHeight
        )
        .padding(8)
}

#Preview("Data List Region") {
    RenameItemsTable()
        .environmentObject(RenameViewModel())
        .frame(
            width: MainWindowMetrics.initialWidth,
            height: MainWindowMetrics.listMinimumHeight
        )
}
