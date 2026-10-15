import SwiftUI

@main
struct StudySpotApp: App {
    @StateObject private var appState: AppState
    
    init() {
        let isUITesting = ProcessInfo.processInfo.arguments.contains("-ui-testing")
        let isDemoArg = ProcessInfo.processInfo.arguments.contains("-demo-mode")
        
        let controller: PersistenceController
        if isUITesting {
            controller = PersistenceController(inMemory: true)
            controller.seedSampleData(context: controller.container.viewContext)
        } else {
            controller = PersistenceController.shared
        }
        
        let state = AppState(persistenceController: controller)
        if isDemoArg || isUITesting {
            state.isDemoMode = true
        }
        
        _appState = StateObject(wrappedValue: state)
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView(appState: appState)
                .background(Color.themeBackground.ignoresSafeArea())
        }
    }
}
