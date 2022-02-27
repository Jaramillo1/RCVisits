//
//  ContentView.swift
//  RCVisits
//
//  Created by Ernesto Jaramillo on 2/26/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var visits: [DailyVisit]
    @State private var errorWrapper: ErrorWrapper?
    @State private var selection: Tab = .featured

    enum Tab {
        case featured
        case list
    }
    
    
    var body: some View {
        TabView(selection: $selection) {

            NavigationView {
                VisitView(visits: $visits) {
                    Task {
                        do {
                            try await VisitStore.save(visits: visits)
                        } catch {
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                        }
                    }
                }
            }
            .task {
                do {
                    visits = try await VisitStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "RCVisits will load sample data and continue.")
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {
                visits = DailyVisit.sampleData
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
             .tabItem {
                 Label("Visits", systemImage: "car")
              }
             .tag(Tab.list)


            CheckMyDistanceRepresentable()
                .tabItem {
                    Label("Distance", systemImage: "ruler")
                }
                .tag(Tab.list)
            
            MapViewWrapper()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(Tab.list)
  
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(visits: .constant(DailyVisit.sampleData))
    }
}
