import SwiftUI

struct ContentView: View {
    @EnvironmentObject var blockList: BlockListManager

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "phone.down.fill")
                            .font(.title)
                            .foregroundStyle(.red)
                        VStack(alignment: .leading) {
                            Text("CallBlock")
                                .font(.headline)
                            Text("Blocks telemarketing and unwanted calls")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Button {
                        blockList.reloadExtension()
                    } label: {
                        Label("Reload Block List", systemImage: "arrow.triangle.2.circlepath")
                    }
                }

                Section("Active Blocks (\(blockList.entries.filter(\.enabled).count))") {
                    if blockList.entries.isEmpty {
                        Text("No entries configured")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(blockList.entries) { entry in
                            BlockEntryRow(entry: entry) {
                                blockList.toggleEntry(entry)
                            }
                        }
                    }
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Enable in Settings", systemImage: "gearshape.fill")
                            .font(.headline)
                        Text("Go to Settings → Phone → Call Blocking & Identification and enable CallBlock Directory.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("CallBlock")
        }
    }
}

struct BlockEntryRow: View {
    let entry: BlockEntry
    let onToggle: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(formattedValue)
                    .font(.body.monospaced())
                if let label = entry.label {
                    Text(label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Toggle("", isOn: .constant(entry.enabled))
                .labelsHidden()
                .onTapGesture { onToggle() }
        }
    }

    private var formattedValue: String {
        switch entry.type {
        case .prefix:
            return entry.value + "*"
        case .phoneNumber:
            return entry.value
        case .label:
            return (entry.label ?? entry.value)
        }
    }
}
