//
//  ViewController.swift
//  IHImageViewEffects
//
//  Created by Md Ibrahim Hassan on 26/07/17.
//  Copyright © 2017 Md Ibrahim Hassan. All rights reserved.
//

import UIKit
import AVFoundation
enum Types : Int {
    case AudienceCheer = 0
    case Confetti = 1
    case Balloons = 2
    case FireWorks = 3
}
enum Colors {
 static let red = UIColor(red: 1.0, green: 0.0, blue: 77.0/255.0, alpha: 1.0)
 static let blue = UIColor.blue
 static let green = UIColor(red: 35.0/255.0 , green: 233/255, blue: 173/255.0, alpha: 1.0)
 static let yellow = UIColor(red: 1, green: 209/255, blue: 77.0/255.0, alpha: 1.0)
 }
 enum Images {
 static let box = UIImage(named: "Box")!
 static let triangle = UIImage(named: "Triangle")!
 static let circle = UIImage(named: "Circle")!
 static let swirl = UIImage(named: "Spiral")!
 }
 class ImageAnimationsViewController: UIViewController {
 var counter = 0
    @IBOutlet weak var imageView: UIImageView!
    var player: AVAudioPlayer?
 var gameTimer: Timer!
 func playSound(soundName : String, extensionName : String) {
 guard let url = Bundle.main.url(forResource: soundName, withExtension: extensionName) else { return }
 do {
 try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
 try AVAudioSession.sharedInstance().setActive(true)
 gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
 player = try AVAudioPlayer(contentsOf: url)
 guard let player = player else { return }
 player.play()
 } catch let error {
 print(error.localizedDescription)
 }
 }
 func runTimedCode() {
 player?.stop()
 self.imageView.layer.sublayers?.removeAll()
 self.emitter = CAEmitterLayer()
 self.emitter.removeFromSuperlayer()
 counter += 1
    if counter % 4 == 0 {
        type = Types.AudienceCheer
        self.playAnimation()
    }
    else if counter % 4 == 1 {
        type = Types.Confetti
        playAnimation()
    }
    else if counter % 4 == 2 {
        type = Types.Balloons
        self.playAnimation()
    }
    else {
        type = Types.FireWorks
        self.playAnimation()
    }
 }
 func closeViewController() {
 self.player?.stop()
 }
    var emitter = CAEmitterLayer()
 var colors:[UIColor] = [
 Colors.red,
 Colors.blue,
 Colors.green,
 Colors.yellow
 ]
 var images:[UIImage] = [
 Images.box,
 Images.triangle,
 Images.circle,
 Images.swirl
 ]
 var velocities:[Int] = [
 100,
 90,
 150,
 200
 ]
 var baloonColors: [UIColor] = [
 UIColor.init(patternImage: #imageLiteral(resourceName: "darkBlue").resizeImage(newWidth: 300)),
 UIColor.init(patternImage: #imageLiteral(resourceName: "darkGreen").resizeImage(newWidth: 300)),
 UIColor.init(patternImage: #imageLiteral(resourceName: "deepRed").resizeImage(newWidth: 300)),
 UIColor.init(patternImage: #imageLiteral(resourceName: "orange").resizeImage(newWidth: 300)),
 UIColor.init(patternImage: #imageLiteral(resourceName: "pink").resizeImage(newWidth: 300)),
 UIColor.init(patternImage: #imageLiteral(resourceName: "skyBlue").resizeImage(newWidth: 300)),
 UIColor.init(patternImage: #imageLiteral(resourceName: "white").resizeImage(newWidth: 300)),
 UIColor.init(patternImage: #imageLiteral(resourceName: "yellow").resizeImage(newWidth: 300))
 ]
 var type = Types.AudienceCheer
 override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
    self.playAnimation()
 }
    func playAnimation(){
        self.view.sendSubview(toBack: imageView)
        switch type {
        case .AudienceCheer:
            self.playSound(soundName: "applause", extensionName: "mp3")
        case .FireWorks:
            emitter = CAEmitterLayer()
            self.createFireWorks()
        case .Balloons:
            emitter.emitterPosition = CGPoint.init(x: self.view.frame.size.width/2, y: self.view.frame.size.height + 100.0)
            emitter.emitterShape = kCAEmitterLayerLine
            emitter.emitterSize = CGSize.init(width: self.view.frame.size.width, height: 2.0)
            emitter.emitterCells = generateBalloonEmitterCells()
            self.imageView.layer.addSublayer(emitter)
            self.playSound(soundName: "balloon", extensionName: "mp3")
        case .Confetti:
            emitter = CAEmitterLayer()
            emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: 0.0)
            emitter.emitterShape = kCAEmitterLayerLine
            emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 100.0)
            emitter.emitterCells = generateEmitterCells()
            self.imageView.layer.addSublayer(emitter)
            self.playSound(soundName: "confettiCannonSingleShotRemoteControlSystem", extensionName: "mp3")
        }
    }
 func createFireWorks(){
 self.playSound(soundName: "firework", extensionName: "mp3")
 let image = UIImage(named: "particle")
 let img: CGImage = (image?.cgImage)!
 emitter.emitterPosition = CGPoint(x: self.imageView.bounds.size.width/2, y: self.imageView.frame.size.height + 10)
 emitter.renderMode = kCAEmitterLayerAdditive
 let emitterCell = CAEmitterCell()
 emitterCell.emissionLongitude = -CGFloat(M_PI / 2)
 emitterCell.emissionLatitude = 0
 emitterCell.lifetime = 2.0
 emitterCell.birthRate = 6
 emitterCell.velocity = 300
 emitterCell.velocityRange = 100
 emitterCell.yAcceleration = 150
 emitterCell.emissionRange = CGFloat(M_PI / 4)
 let newColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5).cgColor
 emitterCell.redRange = 0.5
 emitterCell.greenRange = 0.0
 emitterCell.blueRange = 0.0
 emitterCell.name = "base"
 let flareCell =  CAEmitterCell()
 flareCell.contents = img
 flareCell.emissionLongitude = -CGFloat(4 * M_PI) / 2
 flareCell.scale = 0.4
 flareCell.velocity = 80
 flareCell.birthRate = 45
 flareCell.lifetime = 0.5
 flareCell.yAcceleration = -320
 flareCell.emissionRange = CGFloat(M_PI / 7)
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
 fireworkCell.emissionRange = 2 * CGFloat(M_PI)
 fireworkCell.scaleSpeed = -0.1
 fireworkCell.spin = 2
 fireworkCell.scale = 0.1
 fireworkCell.lifetime = 0.25
 fireworkCell.lifetimeRange = 0.8
 fireworkCell.scaleSpeed = 0.2
 fireworkCell.scaleRange = 1.0
 emitterCell.emitterCells = [flareCell,fireworkCell]
 self.emitter.emitterCells = [emitterCell]
 self.imageView.layer.addSublayer(emitter)
 }
 private func generateBalloonEmitterCells()  -> [CAEmitterCell] {
 var cells : [CAEmitterCell] = [CAEmitterCell]()
 for index in 0..<8 {
 let cell = CAEmitterCell()
 cell.birthRate = 0.5
 cell.lifetime = 10.0
 cell.lifetimeRange = 0.0
 cell.velocity = CGFloat(self.getRandomVelocity())
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
 private func generateEmitterCells() -> [CAEmitterCell] {
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
 private func getRandomVelocity() -> Int {
 return velocities[getRandomNumber()]
 }
 private func getRandomNumber() -> Int {
 return Int(arc4random_uniform(4))
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
 let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
 // Create image context. 0 means scale of device's main screen
 UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
 let context = UIGraphicsGetCurrentContext()!
 //  Fill the rect by the final color
 overlayColor.setFill()
 context.fill(rect)
 //  Make the final shape by masking the drawn color with the images alpha values
 self.draw(in: rect, blendMode: .destinationIn, alpha: 1)
 //  Make the final shape by masking the drawn color with the images alpha values
 let overlayedImage = UIGraphicsGetImageFromCurrentImageContext()!
 //  Release context
 UIGraphicsEndImageContext()
 return overlayedImage
 }
 func resizeImage(newWidth: CGFloat) -> UIImage {
 let scale = newWidth / self.size.width
 let newHeight = self.size.height * scale
 UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
 self.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
 let newImage = UIGraphicsGetImageFromCurrentImageContext()
 UIGraphicsEndImageContext()
 return newImage!
 }
 }
