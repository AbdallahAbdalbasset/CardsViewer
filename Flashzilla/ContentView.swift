//
//  ContentView.swift
//  Flashzilla
//
//  Created by Macbook on 9/12/22.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    
    @State private var engine : CHHapticEngine?
    
    @State private var offset = CGSize.zero
    @State private var isDraging = false
    var body: some View {
        
        let lonPressGesture = LongPressGesture()
            .onEnded{ value in
                withAnimation{
                    isDraging = true
                }
            }
        
        let dragGesture = DragGesture()
            .onChanged{ value in
                offset = value.translation
            }
            .onEnded{ value in
                withAnimation{
                    offset = CGSize.zero
                    isDraging = false
                }
            }
        
        let combined = lonPressGesture.sequenced(before: dragGesture)
        
        Circle()
            .fill(.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDraging ? 1.5 : 1)
            .offset(offset)
            //.gesture(combined)
            .onTapGesture {
                myCustomizedHaptic()
            }
            .onAppear(perform: prepareEngine)
            
    }
    func success() {
        let generator  = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        print("done!")
    }
    
    func prepareEngine() {
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {print("returned"); return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        }
        catch {
            print("There is an error creatin the engine")
        }
        
    }
    
    func myCustomizedHaptic(){
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {print("returned2"); return }
        var events = [CHHapticEvent]()
        
        let density = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [density,sharpness], relativeTime: 0)
        events.append(event)
        
        do{
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        }catch {
            print("can not play that events")
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
