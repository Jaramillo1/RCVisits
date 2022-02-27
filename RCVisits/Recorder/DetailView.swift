/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct DetailView: View {
    @Binding var visit: DailyVisit
    
    @State private var data = DailyVisit.Data()
    @State private var isPresentingEditView = false
    
    var body: some View {
        List {
            Section(header: Text("Recording Info")) {
                NavigationLink(destination: MeetingView(visit: $visit)) {
                    Label("Start Recording", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(visit.lengthInMinutes) minutes")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(visit.theme.name)
                        .padding(4)
                        .foregroundColor(visit.theme.accentColor)
                        .background(visit.theme.mainColor)
                        .cornerRadius(4)
                }
                .accessibilityElement(children: .combine)
            }
            Section(header: Text("Attendees")) {
                ForEach(visit.attendees) { attendee in
                    Label(attendee.name, systemImage: "person")
                }.onDelete(perform: deleteAttendee)
            }
            Section(header: Text("Recording History")) {
                if visit.history.isEmpty {
                    Label("No meetings yet", systemImage: "calendar.badge.exclamationmark")
                }
                ForEach(visit.history) { history in
                    NavigationLink(destination: HistoryView(history: history)) {
                        HStack {
                            Image(systemName: "calendar")
                            Text(history.date, style: .date)
                        }
                    }
                }.onDelete(perform: deleteHistory)
            }
        }
        .navigationTitle(visit.title)
        .toolbar {
            Button("Edit") {
                isPresentingEditView = true
                data = visit.data
            }
        }
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                DetailEditView(data: $data)
                    .navigationTitle(visit.title)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false
                                visit.update(from: data)
                            }
                        }
                    }
            }
        }
    } // body
    
    func deleteAttendee(offsets: IndexSet){
        withAnimation{
            visit.attendees.remove(atOffsets: offsets)
        }
    }
    
    func deleteHistory(offsets: IndexSet){
        withAnimation{
            visit.history.remove(atOffsets: offsets)
        }
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(visit: .constant(DailyVisit.sampleData[0]))
        }
    }
}
