// MIT License
//
// Copyright (c) 2017 Md Ibrahim Hassan
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import AVFoundation
import ReplayKit

enum Types : Int {
    case Confetti = 1
    case Balloons = 2
    case FireWorks = 3
}

enum Colors {
    static let red = UIColor(
        red: 1.0,
        green: 0.0,
        blue: 77.0/255.0,
        alpha: 1.0
    )
    static let blue = UIColor.blue
    static let green = UIColor(
        red: 35.0/255.0,
        green: 233/255,
        blue: 173/255.0,
        alpha: 1.0
    )
    static let yellow = UIColor(
        red: 1,
        green: 209/255,
        blue: 77.0/255.0,
        alpha: 1.0
    )
}

enum Images {
    static let box = #imageLiteral(resourceName: "Box")
    static let triangle = #imageLiteral(resourceName: "Triangle")
    static let circle = #imageLiteral(resourceName: "Circle")
    static let swirl = #imageLiteral(resourceName: "Spiral")
}

class ImageAnimationsViewController: UIViewController {
    
    //RecorderKit Reference
    private let recorder = RPScreenRecorder.shared()
    
    @IBOutlet weak var imageView: UIImageView!
    private var counter = 0
    private var gameTimer: Timer!
    private var emitter = CAEmitterLayer()
    
    private var colors:[UIColor] = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow
    ]
    
    private var images:[UIImage] = [
        Images.box,
        Images.triangle,
        Images.circle,
        Images.swirl
    ]
    
    private var velocities:[Int] = [
        100,
        90,
        150,
        200
    ]
    
    private var baloonColors: [UIColor] = [
        UIColor.init(patternImage: #imageLiteral(resourceName: "darkBlue").resizeImage(newWidth: 300)),
        UIColor.init(patternImage: #imageLiteral(resourceName: "darkGreen").resizeImage(newWidth: 300)),
        UIColor.init(patternImage: #imageLiteral(resourceName: "deepRed").resizeImage(newWidth: 300)),
        UIColor.init(patternImage: #imageLiteral(resourceName: "orange").resizeImage(newWidth: 300)),
        UIColor.init(patternImage: #imageLiteral(resourceName: "pink").resizeImage(newWidth: 300)),
        UIColor.init(patternImage: #imageLiteral(resourceName: "skyBlue").resizeImage(newWidth: 300)),
        UIColor.init(patternImage: #imageLiteral(resourceName: "white").resizeImage(newWidth: 300)),
        UIColor.init(patternImage: #imageLiteral(resourceName: "yellow").resizeImage(newWidth: 300))
    ]
    
    private var type = Types.Balloons
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.isUserInteractionEnabled = true
        setUpLongPressGestureRecognizer()
        playAnimation()
    }
}

// MARK: Long Press Gesture
extension ImageAnimationsViewController {
    private func setUpLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(sender:)))
        longPressGesture.minimumPressDuration = 0.1
        longPressGesture.delaysTouchesBegan = true
        imageView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func longPressAction(sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            recording(state: true)
        } else if (sender.state == .ended) {
            recording(state: false)
        }
    }
}

extension ImageAnimationsViewController {
    
    private func recording(state: Bool) {
#if targetEnvironment(simulator)
        print ("Replay kit screen Recording will not work on Simulator")
        return
#endif
        
        if (state) {
            guard recorder.isAvailable else {
                print("Recording is not available at this time.")
                return
            }
            
            recorder.startRecording{ (error) in
                guard error == nil else {
                    print("There was an error starting the recording.")
                    return
                }
                
                print("Started Recording Successfully")
            }
        } else {
            print("Stopped recording")
            recorder.stopRecording { (preview, error) in
                guard let preview = preview else {
                    print("Preview controller is not available.")
                    return
                }
                
                if (UIDevice.current.userInterfaceIdiom == .pad) {
                    preview.modalPresentationStyle = .fullScreen
                }
                
                preview.previewControllerDelegate = self
                self.present(
                    preview,
                    animated: true,
                    completion: {
                        self.gameTimer.invalidate()
                    }
                )
            }
        }
    }
}

extension ImageAnimationsViewController : RPPreviewViewControllerDelegate {

    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(
            animated: true,
            completion: {
                self.gameTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: false)
            }
        )
    }
}

extension ImageAnimationsViewController {
    
    @objc private func runTimedCode() {
        imageView.layer.sublayers?.removeAll()
        counter += 1
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) { [self] in
            // Your code with delay
            if counter % 3 == 0 {
                emitter = CAEmitterLayer()
                type = Types.FireWorks
                playAnimation()
            } else if counter % 3 == 1 {
                emitter = CAEmitterLayer()
                type = Types.Confetti
                playAnimation()
            } else {
                emitter = CAEmitterLayer()
                type = Types.Balloons
                playAnimation()
            }
        }
    }
    
    private func playAnimation() {
        view.sendSubviewToBack(imageView)
        switch type {
        case .FireWorks:
            emitter = CAEmitterLayer()
            createFireWorks()
        case .Balloons:
            emitter = CAEmitterLayer()
            emitter.emitterPosition = CGPoint.init(x: view.frame.size.width/2, y: view.frame.size.height + 100.0)
            emitter.emitterShape = CAEmitterLayerEmitterShape.line
            emitter.emitterSize = CGSize.init(width: view.frame.size.width, height: 2.0)
            emitter.emitterCells = generateBalloonEmitterCells()
            imageView.layer.addSublayer(emitter)
            playSound(soundName: "balloon", extensionName: "mp3")
        case .Confetti:
            emitter = CAEmitterLayer()
            emitter.emitterPosition = CGPoint(x: view.frame.size.width / 2, y: 0.0)
            emitter.emitterShape = CAEmitterLayerEmitterShape.line
            emitter.emitterSize = CGSize(width: view.frame.size.width, height: 100.0)
            emitter.emitterCells = generateEmitterCellsForConfetti()
            imageView.layer.addSublayer(emitter)
            playSound(soundName: "confettiCannonSingleShotRemoteControlSystem", extensionName: "mp3")
        }
    }
}

// Common Methods
extension ImageAnimationsViewController {
    private func playSound(soundName : String, extensionName : String) {
        guard let _ = Bundle.main.url(forResource: soundName, withExtension: extensionName) else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            gameTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func getRandomVelocity() -> Int {
        func getRandomNumber() -> Int {
            return Int(arc4random_uniform(4))
        }
        return velocities[getRandomNumber()]
    }
}

//Balloons
extension ImageAnimationsViewController {
    private func generateBalloonEmitterCells()  -> [CAEmitterCell] {
        var cells : [CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<8 {
            let cell = CAEmitterCell()
            cell.birthRate = 0.5
            cell.lifetime = 10.0
            cell.lifetimeRange = 0.0
            cell.velocity = CGFloat(getRandomVelocity())
            cell.emissionLongitude = CGFloat(0)
            cell.emissionRange = 0.0
            cell.spinRange = 0.0
            cell.scaleRange = 0.3
            cell.scale = 0.30
            let image : UIImage = UIImage.init(named: "Balloon")!
            let newImage = image.overlayed(by: baloonColors[index])
            cell.contents = newImage.cgImage
            cells.append(cell)
        }
        return cells
    }
}

//Fireworks
extension ImageAnimationsViewController {
    private func createFireWorks(){
        playSound(soundName: "firework", extensionName: "mp3")
        let image = UIImage(named: "particle")
        let img: CGImage = (image?.cgImage)!
        emitter.emitterPosition = CGPoint(x: imageView.bounds.size.width/2, y: imageView.frame.size.height + 10)
        emitter.renderMode = CAEmitterLayerRenderMode.additive
        let emitterCell = CAEmitterCell()
        emitterCell.emissionLongitude = -CGFloat.pi / 2
        emitterCell.emissionLatitude = 0
        emitterCell.lifetime = 2.0
        emitterCell.birthRate = 6
        emitterCell.velocity = 300
        emitterCell.velocityRange = 100
        emitterCell.yAcceleration = 150
        emitterCell.emissionRange = CGFloat.pi / 4
        emitterCell.redRange = 0.5
        emitterCell.greenRange = 0.0
        emitterCell.blueRange = 0.0
        emitterCell.name = "base"
        let flareCell =  CAEmitterCell()
        flareCell.contents = img
        flareCell.emissionLongitude = CGFloat.pi * 2//-CGFloat(4 * M_PI) / 2
        flareCell.scale = 0.4
        flareCell.velocity = 80
        flareCell.birthRate = 45
        flareCell.lifetime = 0.5
        flareCell.yAcceleration = -320
        flareCell.emissionRange = CGFloat.pi / 7//CGFloat(M_PI / 7)
        flareCell.alphaSpeed = -0.7
        flareCell.scaleSpeed = -0.1
        flareCell.scaleRange = 0.1
        flareCell.beginTime = 0.01
        flareCell.duration = 1.7
        let fireworkCell = CAEmitterCell()
        fireworkCell.contents = img
        fireworkCell.birthRate = 19999
        fireworkCell.scale = 0.1
        fireworkCell.velocity = 130
        fireworkCell.lifetime = 100
        fireworkCell.alphaSpeed = -0.2
        fireworkCell.yAcceleration = -60
        fireworkCell.beginTime = 1.5
        fireworkCell.duration = 0.1
        fireworkCell.emissionRange = CGFloat.pi * 2//2 * CGFloat(M_PI)
        fireworkCell.scaleSpeed = -0.1
        fireworkCell.spin = 2
        fireworkCell.scale = 0.1
        fireworkCell.lifetime = 0.25
        fireworkCell.lifetimeRange = 0.8
        fireworkCell.scaleSpeed = 0.2
        fireworkCell.scaleRange = 1.0
        emitterCell.emitterCells = [flareCell,fireworkCell]
        emitter.emitterCells = [emitterCell]
        imageView.layer.addSublayer(emitter)
    }
}


//Confetti
extension ImageAnimationsViewController {
    private func generateEmitterCellsForConfetti() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<16 {
            let cell = CAEmitterCell()
            cell.birthRate = 4.0
            cell.lifetime = 14.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(getRandomVelocity())
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 0.5
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)
            cell.scaleRange = 0.32
            cell.scale = 0.1
            cells.append(cell)
        }
        return cells
    }
    
    private func getNextColor(i:Int) -> CGColor {
        if i <= 4 {
            return colors[0].cgColor
        } else if i <= 8 {
            return colors[1].cgColor
        } else if i <= 12 {
            return colors[2].cgColor
        } else {
            return colors[3].cgColor
        }
    }
    
    private func getNextImage(i:Int) -> CGImage {
        return images[i % 4].cgImage!
    }
}

extension UIImage {
    
    func overlayed(by overlayColor: UIColor) -> UIImage {
        //  Create rect to fit the image
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        // Create image context. 0 means scale of device's main screen
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //  Fill the rect by the final color
        overlayColor.setFill()
        context.fill(rect)
        //  Make the final shape by masking the drawn color with the images alpha values
        draw(in: rect, blendMode: .destinationIn, alpha: 1)
        //  Make the final shape by masking the drawn color with the images alpha values
        let overlayedImage = UIGraphicsGetImageFromCurrentImageContext()!
        //  Release context
        UIGraphicsEndImageContext()
        return overlayedImage
    }
    
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

