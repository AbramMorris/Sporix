//
//  PageViewController.swift
//  Sporix
//
//  Created by User on 31/05/2025.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var pages = [UIViewController]()
    private var pageControl = UIPageControl()
    
    private let pageData: [(image: String, description: String)] = [
        ("football", "Kick off your game with Sporix."),
        ("basketball", "Shoot, score, and track your stats."),
        ("tennis", "Serve up connections with players."),
        ("cricket", "Start your cricket journey now!")
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self

        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        for i in 0..<pageData.count {
            let vcId = "page\(i+1)"
            guard let page = storyboard.instantiateViewController(withIdentifier: vcId) as? UIViewController else {
                fatalError("Missing view controller with id \(vcId)")
            }
            configure(page: page, at: i)
            pages.append(page)
        }

        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }

        setupPageControl()
    }

    private func configure(page: UIViewController, at index: Int) {
        if let imageView = page.view.viewWithTag(1) as? UIImageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: page.view.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: page.view.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: page.view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: page.view.trailingAnchor)
            ])
            imageView.image = UIImage(named: pageData[index].image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }


        if let label = page.view.viewWithTag(2) as? UILabel {
            label.text = pageData[index].description
        }
        
        if let button = page.view.viewWithTag(3) as? UIButton {
            let isLastPage = index == pageData.count - 1
            button.setTitle(isLastPage ? "Start" : "Next", for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)

            if isLastPage {
                button.alpha = 0
                UIView.animate(withDuration: 0.8) {
                    button.alpha = 1.0
                }
            }
        }
    }

    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }

    @objc private func nextButtonTapped(_ sender: UIButton) {
        let currentIndex = sender.tag
        if currentIndex == pages.count - 1 {
            goToMainApp()
        } else {
            let nextIndex = currentIndex + 1
            let nextVC = pages[nextIndex]
            setViewControllers([nextVC], direction: .forward, animated: true)
            pageControl.currentPage = nextIndex
        }
    }

    private func goToMainApp() {
        let storyboard = UIStoryboard(name: "Sports", bundle: nil)
        if let sportsVC = storyboard.instantiateViewController(withIdentifier: "tab") as? UITabBarController {
            sportsVC.modalPresentationStyle = .fullScreen
            present(sportsVC, animated: true)
        } else {
            print("Could not cast to HomeViewController")
        }
    }


    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentIndex + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed, let visibleVC = viewControllers?.first,
           let index = pages.firstIndex(of: visibleVC) {
            pageControl.currentPage = index
        }
    }
}
