import Foundation

struct BlockListStore {
    static let appGroupIdentifier = "group.com.example.CallBlock"

    static let shared: BlockListStore? = {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupIdentifier
        ) else { return nil }
        return BlockListStore(containerURL: containerURL)
    }()

    private let containerURL: URL
    private let blockListURL: URL

    init?(containerURL: URL) {
        self.containerURL = containerURL
        self.blockListURL = containerURL.appendingPathComponent("blocklist.json")
    }

    func loadBlockList() -> [BlockEntry] {
        guard let data = try? Data(contentsOf: blockListURL),
              let entries = try? JSONDecoder().decode([BlockEntry].self, from: data) else {
            return []
        }
        return entries
    }

    func saveBlockList(_ entries: [BlockEntry]) {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: blockListURL)
    }
}
