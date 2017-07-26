//
//  ViewController.swift
//  IHImageViewEffects
//
//  Created by Md Ibrahim Hassan on 26/07/17.
//  Copyright © 2017 Md Ibrahim Hassan. All rights reserved.
//

import UIKit

class IHImageViewEffects : UIImageView{
    
    private var emitter = CAEmitterLayer()

    override init(image: UIImage?) {
        super.init(image: image)

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
        //        emitter.emitterShape = kCAEmitterLayerLine
        //        emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
        //        emitter.emitterCells = generateEmitterCells()
        //        self.imageView.layer.addSublayer(emitter)
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.emitter.removeFromSuperlayer()
            self.createFireWorks()
        }
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
    

    
    func createFireWorks(){
        
        let image = UIImage(named: "particle")
        let img: CGImage = (image?.cgImage)!
        
        print(self.frame.size.width/2)
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width/2, y: self.frame.size.height + 10)
        emitter.renderMode = kCAEmitterLayerAdditive
        
        
        let emitterCell = CAEmitterCell()
        emitterCell.emissionLongitude = -CGFloat(M_PI / 2)
        emitterCell.emissionLatitude = 0
        emitterCell.lifetime = 2.6
        emitterCell.birthRate = 6
        emitterCell.velocity = 300
        emitterCell.velocityRange = 100
        emitterCell.yAcceleration = 150
        emitterCell.emissionRange = CGFloat(M_PI / 4)
        let newColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5).cgColor
        emitterCell.color = newColor;
        emitterCell.redRange = 0.9;
        emitterCell.greenRange = 0.9;
        emitterCell.blueRange = 0.9;
        emitterCell.name = "base"
        
        let flareCell =  CAEmitterCell()
        flareCell.contents = img;
        flareCell.emissionLongitude = -CGFloat(4 * M_PI) / 2;
        flareCell.scale = 0.4;
        flareCell.velocity = 80;
        flareCell.birthRate = 45;
        flareCell.lifetime = 0.5;
        flareCell.yAcceleration = -350;
        flareCell.emissionRange = CGFloat(M_PI / 7);
        flareCell.alphaSpeed = -0.7;
        flareCell.scaleSpeed = -0.1;
        flareCell.scaleRange = 0.1;
        flareCell.beginTime = 0.01;
        flareCell.duration = 1.7;
        
        let fireworkCell = CAEmitterCell()
        
        fireworkCell.contents = img;
        fireworkCell.birthRate = 19999;
        fireworkCell.scale = 0.6;
        fireworkCell.velocity = 130;
        fireworkCell.lifetime = 100;
        fireworkCell.alphaSpeed = -0.2;
        fireworkCell.yAcceleration = -80;
        fireworkCell.beginTime = 1.5;
        fireworkCell.duration = 0.1;
        fireworkCell.emissionRange = 2 * CGFloat(M_PI);
        fireworkCell.scaleSpeed = -0.1;
        fireworkCell.spin = 2;
        
        emitterCell.emitterCells = [flareCell,fireworkCell]
        self.emitter.emitterCells = [emitterCell]
        
        self.layer.addSublayer(emitter)
    }
    
}



class ViewController: UIViewController {
    
    
    @IBOutlet var imageView: UIImageView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
 
        
    }
    

    
   
    

    
    
}


