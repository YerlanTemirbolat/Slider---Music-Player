//
//  ContentView.swift
//  Slider
//
//  Created by Admin on 9/1/20.
//  Copyright © 2020 Yerlan. All rights reserved.
//

import AVFoundation
import SwiftUI

class PlayerViewModel: ObservableObject {
    @Published public var maxDuration = 0.0
    private var player: AVAudioPlayer?
    
    public func play() {
        playSong(name: "Dark Night")
        player?.play()
    }
    
    public func stop() {
        player?.stop()
    }
    
    public func setTime(value: Float) {
        guard let time = TimeInterval(exactly: value) else { return }
        player?.currentTime = time
        player?.play()
    }
    
    private func playSong(name: String) {
        guard let audioPath = Bundle.main.path(forResource: name, ofType: "mp3") else { return }
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            maxDuration = player?.duration ?? 0.0
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView: View {
    
    @State private var progress: Float = 0
    @ObservedObject var viewModel = PlayerViewModel()
    
    var body: some View {
        VStack {
            Slider(value: Binding(get: {
                Double(self.progress)
            }, set: { (newValue) in
                self.progress = Float(newValue)
                self.viewModel.setTime(value: Float(newValue))
            }), in: 0 ... viewModel.maxDuration)
                .padding()
            
            HStack {
                Button(action: {
                    self.viewModel.play()
                }) {
                    Text("Play")
                }
                .frame(width: 100, height: 60)
                .background(Color.orange)
                .cornerRadius(10)
                
                Button(action: {
                    self.viewModel.stop()
                }) {
                    Text("Stop")
                }
                .frame(width: 100, height: 60)
                .background(Color.orange)
                .cornerRadius(10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
