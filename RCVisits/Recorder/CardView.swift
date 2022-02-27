/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct CardView: View {
    let visit: DailyVisit
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(visit.title)
                .accessibilityAddTraits(.isHeader)
                .font(.headline)
            Spacer()
            HStack {
                Label("\(visit.attendees.count)", systemImage: "person.3")
                    .accessibilityLabel("\(visit.attendees.count) attendees")
                Spacer()
                Label("\(visit.lengthInMinutes)", systemImage: "clock")
                    .accessibilityLabel("\(visit.lengthInMinutes) minute meeting")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(visit.theme.accentColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var visit = DailyVisit.sampleData[0]
    static var previews: some View {
        CardView(visit: visit)
            .background(visit.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
