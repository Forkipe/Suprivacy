import SwiftUI

@main
struct SuprivacyApp: App {
    init() {
            // Set the appearance globally
            NSApplication.shared.appearance = NSAppearance(named: .darkAqua)
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
