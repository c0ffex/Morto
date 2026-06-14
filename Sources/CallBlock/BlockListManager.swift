import Foundation
import CallKit
import CallBlockShared

final class BlockListManager: ObservableObject {
    @Published var entries: [BlockEntry] = []
    @Published var extensionEnabled = false

    private let store: BlockListStore?
    private let appGroup = "group.com.example.CallBlock"

    init() {
        if let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroup
        ) {
            self.store = BlockListStore(containerURL: containerURL)
        } else {
            self.store = nil
        }
        loadEntries()
    }

    func loadEntries() {
        guard let store else {
            entries = bundledDefaults()
            return
        }

        let loaded = store.loadBlockList()
        if loaded.isEmpty {
            entries = bundledDefaults()
            saveEntries()
        } else {
            entries = loaded
        }
    }

    private func bundledDefaults() -> [BlockEntry] {
        guard let url = Bundle.module.url(
            forResource: "blocklist",
            withExtension: "json"
        ),
              let data = try? Data(contentsOf: url),
              let entries = try? JSONDecoder().decode([BlockEntry].self, from: data) else {
            return CarrierData.defaultBlockList()
        }
        return entries
    }

    func saveEntries() {
        store?.saveBlockList(entries)
    }

    func toggleEntry(_ entry: BlockEntry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[index] = BlockEntry(
            value: entry.value,
            type: entry.type,
            label: entry.label,
            enabled: !entry.enabled
        )
        saveEntries()
    }

    func addEntry(_ entry: BlockEntry) {
        entries.append(entry)
        saveEntries()
    }

    func removeEntry(_ entry: BlockEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }

    func reloadExtension() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(
            withIdentifier: "com.example.CallBlock.CallBlockDirectory"
        ) { error in
            if let error {
                print("Failed to reload extension: \(error.localizedDescription)")
            }
        }
    }
}
