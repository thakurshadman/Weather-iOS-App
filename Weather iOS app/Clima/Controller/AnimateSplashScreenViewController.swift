//
//  AnimateSplashScreenViewController.swift
//  Clima
//
//  Created by Shadman Thakur on 12/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class AnimateSplashScreenViewController: UIViewController {

    let splashImage: UIImageView = {
        let splashImage = UIImageView(frame: CGRect(x:0, y:0, width: 200, height: 200))
        splashImage.image = UIImage(named: "splashIcon")
        return splashImage
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(splashImage)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        splashImage.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.animate()
        })
    }
    func animate(){
        UIView.animate(withDuration: 2,
            animations: {
                let size = self.view.frame.size.width * 3.5
                let newX = size - self.view.frame.size.width
                let newY = self.view.frame.size.height - size
                self.splashImage.frame = CGRect(x:-(newX/2), y:newY/2 , width: size , height: size )
                self.splashImage.alpha = 0
            }
        )
        UIView.animate(withDuration: 3.5,
            animations: {
                self.splashImage.alpha = 0
            }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let weatherVC = storyboard.instantiateViewController(withIdentifier: "weatherViewController") as! WeatherViewController
                    weatherVC.modalTransitionStyle = .crossDissolve
                    weatherVC.modalPresentationStyle = .fullScreen
                    self.present(weatherVC, animated: true, completion:nil )
                }
            }
            })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
