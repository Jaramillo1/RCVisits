/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var visit: DailyVisit
    @StateObject var visitTimer = VisitTimer()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(visit.theme.mainColor)
            VStack {
                MeetingHeaderView(secondsElapsed: visitTimer.secondsElapsed, secondsRemaining: visitTimer.secondsRemaining, theme: visit.theme)
                MeetingTimerView(speakers: visitTimer.speakers, isRecording: isRecording, theme: visit.theme)
                MeetingFooterView(speakers: visitTimer.speakers, skipAction: visitTimer.skipSpeaker)
            }
        }
        .padding()
        .foregroundColor(visit.theme.accentColor)
        .onAppear {
            visitTimer.reset(lengthInMinutes: visit.lengthInMinutes, attendees: visit.attendees)
            visitTimer.speakerChangedAction = {
                player.seek(to: .zero)
                player.play()
            }
            speechRecognizer.reset()
            speechRecognizer.transcribe()
            isRecording = true
            visitTimer.startVisit()
        }
        .onDisappear {
            visitTimer.stopVisit()
            speechRecognizer.stopTranscribing()
            isRecording = false
            let newHistory = History(attendees: visit.attendees, lengthInMinutes: visit.timer.secondsElapsed / 60, transcript: speechRecognizer.transcript)
            visit.history.insert(newHistory, at: 0)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(visit: .constant(DailyVisit.sampleData[0]))
    }
}
