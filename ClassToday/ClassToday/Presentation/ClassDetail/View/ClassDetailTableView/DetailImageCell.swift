//
//  DetailImageCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit
import SnapKit

protocol DetailImageCellDelegate: AnyObject {
    func present(_ viewController: UIViewController)
}

class DetailImageCell: UITableViewCell {

    // MARK: - Views

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: contentView.frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isOpaque = true
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()

    // MARK: - Properties

    weak var delegate: DetailImageCellDelegate?
    static var identifier = "DetailImageCell"
    private var images: [UIImage]? = []

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchImageView(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.isEnabled = true
        tapGesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func configureUI() {
        let width = contentView.frame.width
        let height = contentView.frame.height
        guard let images = images else { return }

        for index in 0 ..< images.count {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height))
            imageView.contentMode = .scaleAspectFill
            imageView.image = images[index]
            imageView.isUserInteractionEnabled = true
            scrollView.addSubview(imageView)
        }

        contentView.addSubview(scrollView)
        contentView.addSubview(pageControl)
        scrollView.contentSize = CGSize(width: CGFloat(images.count) * contentView.frame.maxX, height: 0)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        pageControl.numberOfPages = images.count
        pageControl.snp.makeConstraints {
            $0.width.bottom.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
    }

    func configureWith(images: [UIImage]?) {
        guard let images = images else { return }
        self.images = images
        configureUI()
    }

    override func prepareForReuse() {
        scrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    // MARK: - Actions

    @objc func touchImageView(_ sender: UITapGestureRecognizer) {
        if let images = images, images.isEmpty {
            return
        }
        let selectedIndex = pageControl.currentPage
        let fullImageViewController = FullImagesViewController(images: images, startIndex: selectedIndex)
        delegate?.present(fullImageViewController)
    }
}

// MARK: - ScrollViewDelegate

extension DetailImageCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
}
