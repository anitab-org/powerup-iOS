import UIKit
import AVFoundation
import AudioToolbox

/**
 Creates a strong reference to AVAudioPlayer and plays a sound file. Convenience class to declutter controller classes.

 Example Use
 ```
 let soundPlayer : SoundPlayer? = SoundPlayer()
 guard let player = self.soundPlayer else {return}
 // player.playSound(fileName: String, volume: Float)
 player.playSound("sound.mp3", 0.5)
 ```

  - Author: Cadence Holmes 2018
 */
class SoundPlayer {
    var player: AVAudioPlayer?
    var numberOfLoops: Int = 1

    init () {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    /**
     Handles checking for AVAudioPlayer and playing a sound.
     
     - throws: print(error.localizedDescription)
     
     - parameters:
        - fileName : String - file name as it appears in Sounds.xcassets
        - volume : Float - volume scaled 0.0 - 1.0
    */
    func playSound(_ fileName: String, _ volume: Float) {
        guard let sound = NSDataAsset(name: fileName) else { return }

        do {
            player = try AVAudioPlayer(data: sound.data)

            guard let soundplayer = player else { return }
            soundplayer.numberOfLoops = numberOfLoops
            soundplayer.volume = volume
            soundplayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
