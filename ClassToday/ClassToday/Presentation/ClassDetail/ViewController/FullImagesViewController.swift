//
//  File.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/20.
//

import UIKit
import SnapKit

class FullImagesViewController: UIViewController {

    // MARK: Views

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: CGFloat(images?.count ?? 0) * view.frame.maxX, height: 0)
        return scrollView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = images?.count ?? 0
        pageControl.isOpaque = true
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: Properties

    private var images: [UIImage]? = []
    private var startIndex: Int = 0

    // MARK: Initialize

    init(images: [UIImage]?, startIndex: Int) {
        self.images = images
        self.startIndex = startIndex
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .coverVertical
        view.backgroundColor = .black
        let width = view.frame.width
        let height = view.frame.height
        guard let images = images else { return }

        for index in 0 ..< images.count {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height))
            imageView.contentMode = .scaleAspectFit
            imageView.image = images[index]
            scrollView.addSubview(imageView)
        }
        pageControl.currentPage = startIndex
        scrollView.contentOffset = CGPoint(x: (startIndex) * Int(width), y: 0)

        view.addSubview(scrollView)
        scrollView.addSubview(pageControl)
        scrollView.addSubview(dismissButton)
        pageControl.snp.makeConstraints {
            $0.width.centerX.bottom.equalTo(view)
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
    }

    // MARK: Actions

    @objc func dismiss(_ button: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: ScrollViewDelegate

extension FullImagesViewController: UIScrollViewDelegate {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
}
