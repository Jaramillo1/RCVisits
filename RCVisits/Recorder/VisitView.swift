/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct VisitView: View {
    @Binding var visits: [DailyVisit]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingNewVisitView = false
    @State private var newVisitData = DailyVisit.Data()
    let saveAction: ()->Void
    
    var body: some View {
        List {
            ForEach($visits) { $scrum in
                NavigationLink(destination: DetailView(visit: $scrum)) {
                    CardView(visit: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
            }.onDelete(perform: deleteMeeting)
        }
        .navigationTitle("My Visits")
        .toolbar {
            Button(action: {
                isPresentingNewVisitView = true
            }) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Visit")
        }
        .sheet(isPresented: $isPresentingNewVisitView) {
            NavigationView {
                DetailEditView(data: $newVisitData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewVisitView = false
                                newVisitData = DailyVisit.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newScrum = DailyVisit(data: newVisitData)
                                visits.append(newScrum)
                                isPresentingNewVisitView = false
                                newVisitData = DailyVisit.Data()
                            }
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    
    
    func deleteMeeting(offsets: IndexSet){
        withAnimation{
            visits.remove(atOffsets: offsets)
        }
    }
}

struct VisitsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VisitView(visits: .constant(DailyVisit.sampleData), saveAction: {})
        }
    }
}

