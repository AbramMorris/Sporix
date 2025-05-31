//
//  ViewController.swift
//  Sporix
//
//  Created by User on 28/05/2025.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        playLottieAnimation()
    }

    private func playLottieAnimation() {
        guard let animation = LottieAnimation.named("lottiesplash") else {
            print("Could not load lottiesplash.json")
            return
        }

        animationView = LottieAnimationView(animation: animation)
        guard let animationView = animationView else { return }

        animationView.frame = view.bounds
        view.addSubview(animationView)

        animationView.play { [weak self] finished in
            guard self != nil else { return }
            if finished {
                print("Start Navigate >>>>>>>>>>>>>>>>>>>>>>>>>>>")
                //self.navigateToOnBoarding()
                self?.navigateToSportsScreen()
            }
            
        }
    }

    private func navigateToOnBoarding() {
        let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        if let onBoardingVC = storyboard.instantiateInitialViewController() {
            onBoardingVC.modalPresentationStyle = .fullScreen
            present(onBoardingVC, animated: true)
        } else {
            print("Could not instantiate initial from OnBoarding storyboard")
        }
    }

    private func navigateToSportsScreen() {
        let storyboard = UIStoryboard(name: "Sports", bundle: nil)
        if let sportsVC = storyboard.instantiateViewController(withIdentifier: "Home") as? SportsViewController {
            sportsVC.modalPresentationStyle = .fullScreen
            present(sportsVC, animated: true)
        } else {
            print("Could not cast to HomeViewController")
        }
    }

}


