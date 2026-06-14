import Foundation
import CallBlockShared

enum CarrierPrefix {
    static let telemarketing: [String] = [
        "0303",
    ]

    static let financialServices: [String] = [
        "0304",
    ]
}

struct CarrierData {
    static func defaultBlockList() -> [BlockEntry] {
        var entries: [BlockEntry] = []

        for prefix in CarrierPrefix.telemarketing {
            entries.append(BlockEntry(
                value: prefix,
                type: .prefix,
                label: "Telemarketing (0303)",
                enabled: true
            ))
        }

        for prefix in CarrierPrefix.financialServices {
            entries.append(BlockEntry(
                value: prefix,
                type: .prefix,
                label: "Financial Services (0304)",
                enabled: false
            ))
        }

        return entries
    }
}
