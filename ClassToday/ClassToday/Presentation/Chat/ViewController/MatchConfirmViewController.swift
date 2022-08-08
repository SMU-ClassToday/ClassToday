//
//  MatchConfirmViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/07/30.
//

import UIKit

protocol MatchConfirmViewControllerDelegate: AnyObject {
    func confirmMatch()
}

class MatchConfirmViewController: UIViewController {

    private lazy var customNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.setItems([customNavigationItem], animated: true)
        return navigationBar
    }()

    private lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem(title: "매칭하기")
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapBackButton(_:)))
        let rightButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapEnrollButton(_:)))
        leftButton.tintColor = UIColor.mainColor
        rightButton.tintColor = UIColor.mainColor
        item.leftBarButtonItem = leftButton
        item.rightBarButtonItem = rightButton
        return item
    }()
    
    private lazy var sellerLabel: UILabel = {
        let label = UILabel()
        label.text = "강사: "
        return label
    }()
    
    private lazy var buyerLabel: UILabel = {
        let label = UILabel()
        label.text = "학생: "
        return label
    }()
    
    private lazy var dayWeekLabel: UILabel = {
        let label = UILabel()
        label.text = "수업요일: "
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "수업시간: "
        return label
    }()
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "수업장소: "
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "수업가격: "
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        [
            sellerLabel,
            buyerLabel,
            dayWeekLabel,
            timeLabel,
            placeLabel,
            priceLabel
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        return stackView
    }()
    
    func configureNavBar() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    init(match: Match) {
        self.match = match
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: MatchConfirmViewControllerDelegate?
    private let match: Match
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configure()
    }
}

extension MatchConfirmViewController {
    private func configureUI() {
        configureNavBar()
        view.backgroundColor = .white
        [
            stackView
        ].forEach { view.addSubview($0) }
        
        let commonInset: CGFloat = 15.0
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
        }
    }
    
    private func configure() {
        sellerLabel.text = "강사: \(match.seller.name)"
        buyerLabel.text = "학생: \(match.buyer.name)"
        timeLabel.text = "수업시간: \(match.time ?? "")"
        placeLabel.text = "수업장소: \(match.place ?? "")"
        priceLabel.text = "가격: \(match.price ?? "")"
    }
}

extension MatchConfirmViewController {
    @objc func didTapBackButton(_ button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapEnrollButton(_ button: UIBarButtonItem) {
        delegate?.confirmMatch()
        dismiss(animated: true, completion: nil)
    }
}
