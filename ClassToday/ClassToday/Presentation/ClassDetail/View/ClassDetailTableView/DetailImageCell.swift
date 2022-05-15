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
        scrollView.contentSize = CGSize(width: CGFloat(images?.count ?? 0) * contentView.frame.maxX, height: 0)
        return scrollView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = images?.count ?? 0
        pageControl.isOpaque = true
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var scrollContentView = UIView()
    
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
        guard let images = images else { return }

        for index in 0 ..< images.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.image = images[index]
            imageView.isUserInteractionEnabled = true
            stackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width)
                $0.height.equalTo(contentView.frame.height)
            }
        }

        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        scrollContentView.addSubview(stackView)
        scrollContentView.addSubview(pageControl)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints {
            $0.width.bottom.centerX.equalTo(contentView)
            $0.height.equalTo(30)
        }
    }

    func configureWith(images: [UIImage]?) {
        guard let images = images else { return }
        self.images = images
        configureUI()
    }

    // MARK: - Actions

    @objc func touchImageView(_ sender: UITapGestureRecognizer) {
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
