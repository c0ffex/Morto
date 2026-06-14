import Foundation

public enum BlockEntryType: String, Codable {
    case phoneNumber
    case prefix
    case label
}

public struct BlockEntry: Codable, Identifiable, Equatable {
    public let id: UUID
    public let value: String
    public let type: BlockEntryType
    public let label: String?
    public let enabled: Bool

    public init(value: String, type: BlockEntryType, label: String? = nil, enabled: Bool = true) {
        self.id = UUID()
        self.value = value
        self.type = type
        self.label = label
        self.enabled = enabled
    }
}
