//
//  TabBarViewController.swift
//  Sporix
//
//  Created by abram on 08/06/2025.
//

//  TabBarViewController.swift
//  Sporix

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let centerButton = UIButton()
    private var circleLayer: CALayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupCustomTabBar()
        setupCenterButton()
        addCircleLayer()
//        updateCircleLayer(for: selectedIndex)
    }

    private func setupCustomTabBar() {
        if traitCollection.userInterfaceStyle == .dark {
            tabBar.backgroundColor = .black
        } else {
            tabBar.backgroundColor = .white
        }

        tabBar.tintColor = UIColor(named: "TabBarSelected") ?? .systemBlue
        tabBar.unselectedItemTintColor = UIColor(named: "TabBarUnselected") ?? .lightGray

        tabBar.layer.cornerRadius = 25
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.clear.cgColor

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurView, at: 0)
    }

    private func setupCenterButton() {
        let image = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
        centerButton.setImage(image, for: .normal)
        centerButton.tintColor = .white
        centerButton.backgroundColor = UIColor(named: "CenterButtonColor") ?? UIColor.systemBlue
        centerButton.layer.cornerRadius = 35
        centerButton.layer.shadowColor = UIColor.systemBlue.cgColor
        centerButton.layer.shadowOpacity = 0.5
        centerButton.layer.shadowOffset = .zero
        centerButton.layer.shadowRadius = 10

        centerButton.frame = CGRect(x: (view.bounds.width / 2) - 35, y: -20, width: 70, height: 70)
        tabBar.addSubview(centerButton)

        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
    }

    @objc private func centerButtonTapped() {
        self.selectedIndex = 2
        animateCenterButton()
//        updateCircleLayer(for: 2)
    }

    private func animateCenterButton() {
        UIView.animate(withDuration: 0.2,
                       animations: {
                           self.centerButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       },
                       completion: { _ in
                           UIView.animate(withDuration: 0.2) {
                               self.centerButton.transform = CGAffineTransform.identity
                           }
                       })
    }

    private func addCircleLayer() {
        circleLayer = CALayer()
        circleLayer?.backgroundColor = UIColor.clear.cgColor
        circleLayer?.borderWidth = 2
        circleLayer?.cornerRadius = 25
//        updateCircleBorderColor()
        tabBar.layer.addSublayer(circleLayer!)
    }

//    private func updateCircleLayer(for index: Int) {
//        guard let circleLayer = circleLayer else { return }
//
//        let tabBarButtons = tabBar.subviews.filter { $0 is UIControl && $0 != centerButton }
//        if index < tabBarButtons.count {
//            let itemFrame = tabBarButtons[index].frame
//
//            let diameter: CGFloat = 50
//            let x = itemFrame.midX - diameter / 2
//            let y = itemFrame.midY - diameter / 2
//
//            UIView.animate(withDuration: 0.25) {
//                self.circleLayer?.frame = CGRect(x: x, y: y, width: diameter, height: diameter)
//                self.circleLayer?.cornerRadius = diameter / 2
//            }
//        }
//    }

//    private func updateCircleBorderColor() {
//        if traitCollection.userInterfaceStyle == .dark {
//            circleLayer?.borderColor = UIColor.systemBlue.cgColor
//        } else {
//            circleLayer?.borderColor = UIColor.gray.cgColor
//        }
//    }

    // Keep the center button and circle layer in place when layout updates
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        centerButton.center = CGPoint(x: tabBar.center.x, y: tabBar.frame.minY)

        // Update circle layer position to selected tab
//        updateCircleLayer(for: selectedIndex)
    }

    // Detect dark/light mode changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                tabBar.backgroundColor = .black
            } else {
                tabBar.backgroundColor = .white
            }

//            updateCircleBorderColor()
        }
    }

    // Animate circle on tab switch
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = viewControllers?.firstIndex(of: viewController) {
//            updateCircleLayer(for: index)
        }
    }
}

