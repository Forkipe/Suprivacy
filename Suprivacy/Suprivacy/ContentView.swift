import SwiftUI
import AVFoundation

enum SideBarItem: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    case support
    case description
    case compressor
    case concepts
}

struct ContentView: View {
    @State var sideBarVisibility:NavigationSplitViewVisibility = .doubleColumn
    @State var selectedSideBarItem:SideBarItem = .support
    var body: some View {
        ZStack {
            NavigationSplitView(columnVisibility: $sideBarVisibility) {
                List(SideBarItem.allCases, selection: $selectedSideBarItem) { item in
                    NavigationLink(
                        item.rawValue.localizedCapitalized,
                        value: item
                    )
                }.background {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [.purple, .purple, .blue], startPoint: .trailing, endPoint: .leading))
                        VStack {
                            Spacer()
                            HStack {
                                Text("v1.0.3")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                }
            } detail: {
                switch selectedSideBarItem {
                case .support:
                    PrivacySupport()
                case .description:
                    DescriptionIcon()
                case .compressor:
                    ImageResizeView()
                case .concepts:
                    ConceptImagine()
                }
            }
        }
    }
}

