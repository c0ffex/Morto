import SwiftUI

@main
struct CallBlockApp: App {
    @StateObject private var blockList = BlockListManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(blockList)
        }
    }
}
