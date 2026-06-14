import CallKit
import CallBlockShared

final class CallDirectoryProvider: CXCallDirectoryProvider {
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        defer { context.completeRequest() }

        guard let store = BlockListStore.shared else {
            context.completeRequest()
            return
        }

        let entries = store.loadBlockList()

        for entry in entries where entry.enabled {
            switch entry.type {
            case .phoneNumber:
                context.addBlockingEntry(
                    withNextSequentialPhoneNumber: CXCallDirectoryPhoneNumber(entry.value) ?? 0
                )
            case .prefix:
                if let prefixValue = CXCallDirectoryPhoneNumber(entry.value) {
                    let rangeStart = prefixValue * 10_000_000
                    let rangeEnd = rangeStart + 9_999_999
                    context.addBlockingEntry(
                        withNextSequentialPhoneNumber: rangeStart
                    )
                    if rangeEnd > rangeStart {
                        context.addBlockingEntry(
                            withNextSequentialPhoneNumber: rangeEnd
                        )
                    }
                }
            case .label:
                if let labelValue = CXCallDirectoryPhoneNumber(entry.value) {
                    context.addIdentificationEntry(
                        withNextSequentialPhoneNumber: labelValue,
                        label: entry.label ?? entry.value
                    )
                }
            }
        }
    }
}
