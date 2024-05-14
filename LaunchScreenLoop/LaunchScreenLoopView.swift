//
//  LaunchScreenLoopView.swift
//  LaunchScreenLoop
//
//  Created by KOTA TAKAHASHI on 2024/05/14.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewControllerRepresentable {
    @Binding var isPlaying: Bool
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        if isPlaying {
            playerController.player?.play()
        } else {
            playerController.player?.pause()
        }
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: Bundle.main.url(forResource: "Smile_Loop", withExtension: "mp4")!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false
        playerViewController.videoGravity = .resizeAspectFill
        
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
        
        return playerViewController
    }
}

struct LaunchScreenLoopView: View {
    @State private var showOnboarding = false
    @State private var isPlaying = true
    
    var body: some View {
        ZStack {
            PlayerView(isPlaying: $isPlaying)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPlaying.toggle()
                }
            
            VStack {
                Spacer()
                
                Button(action: {
                    showOnboarding = true
                    isPlaying = false
                }) {
                    Text("次へ")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
        .fullScreenCover(isPresented: $showOnboarding, onDismiss: {
            isPlaying = true
        }) {
            OnboardingView()
        }
    }
}
#Preview {
    LaunchScreenLoopView()
}
