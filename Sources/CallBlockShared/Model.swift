import Foundation

enum BlockEntryType: String, Codable {
    case phoneNumber
    case prefix
    case label
}

struct BlockEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let value: String
    let type: BlockEntryType
    let label: String?
    let enabled: Bool

    init(value: String, type: BlockEntryType, label: String? = nil, enabled: Bool = true) {
        self.id = UUID()
        self.value = value
        self.type = type
        self.label = label
        self.enabled = enabled
    }
}
