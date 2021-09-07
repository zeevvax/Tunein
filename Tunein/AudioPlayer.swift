//
// Created by Zeev Vax on 9/6/21.
//

import Foundation
import AVFoundation

class AudioPlayer {
  static let shared = AudioPlayer()

  private var player : AVPlayer?

  func playAudio(path: String) {
    player?.pause()
    guard let url = path.httpsURL() else { return }
    let playerItem = AVPlayerItem.init(url: url)
    player = AVPlayer.init(playerItem: playerItem)
    player?.play()
  }

  func pauseAudio(path: String) {
    player?.pause()
  }
}
