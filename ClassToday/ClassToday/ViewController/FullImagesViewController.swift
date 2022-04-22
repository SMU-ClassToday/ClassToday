//
//  File.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/20.
//

import UIKit
import SnapKit

protocol FullImagesViewControllerDelegate {
    func getImages() -> [UIImage]?
}

class FullImagesViewController: UIViewController {
    private var images: [UIImage]? = []
    var delegate: FullImagesViewControllerDelegate?

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

    @objc func dismiss(_ button: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        configureUI()
    }

    private func configureData() {
        images = delegate?.getImages()
    }

    private func configureUI() {
        let width = view.frame.width
        let height = view.frame.height
        guard let images = images else { return }

        for index in 0 ..< images.count {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height))
            imageView.contentMode = .scaleAspectFit
            imageView.image = images[index]
            scrollView.addSubview(imageView)
        }

        view.addSubview(scrollView)
        scrollView.addSubview(pageControl)
        scrollView.addSubview(dismissButton)
        pageControl.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom)
        }
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
    }
}

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
