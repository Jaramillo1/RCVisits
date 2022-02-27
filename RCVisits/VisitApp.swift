/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

@main
struct VisitApp: App {
    @StateObject private var store = VisitStore()
//    @State private var errorWrapper: ErrorWrapper?
    
    var body: some Scene {
        WindowGroup {
            ContentView(visits: $store.visits)
            
            
            
//            NavigationView {
//                VisitView(visits: $store.visits) {
//                    Task {
//                        do {
//                            try await VisitStore.save(visits: store.visits)
//                        } catch {
//                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
//                        }
//                    }
//                }
//            }
//            .task {
//                do {
//                    store.visits = try await VisitStore.load()
//                } catch {
//                    errorWrapper = ErrorWrapper(error: error, guidance: "Scrumdinger will load sample data and continue.")
//                }
//            }
//            .sheet(item: $errorWrapper, onDismiss: {
//                store.visits = DailyVisit.sampleData
//            }) { wrapper in
//                ErrorView(errorWrapper: wrapper)
//            }
        }
    }
}
