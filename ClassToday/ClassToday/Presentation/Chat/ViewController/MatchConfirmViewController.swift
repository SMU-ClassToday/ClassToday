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

//TODO: - date관련 라벨 추가하기
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
        label.text = "강사"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var sellerLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .mainColor
        return label
    }()
    
    private lazy var sellerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(sellerLabel)
        stackView.addArrangedSubview(sellerLabel2)
        return stackView
    }()
    
    private lazy var buyerLabel: UILabel = {
        let label = UILabel()
        label.text = "학생"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var buyerLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .mainColor
        return label
    }()
    
    private lazy var buyerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(buyerLabel)
        stackView.addArrangedSubview(buyerLabel2)
        return stackView
    }()
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.addArrangedSubview(sellerStackView)
        stackView.addArrangedSubview(buyerStackView)
        return stackView
    }()
    
    private lazy var dayWeekLabel: UILabel = {
        let label = UILabel()
        label.text = "수업요일"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var dayWeekLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "수업시간"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var timeLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        return label
    }()
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "수업장소"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var placeLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "수업가격"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var priceLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        return label
    }()
    
    private lazy var mapView: NaverMapView = {
        let mapView = NaverMapView()
        return mapView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        [
            userStackView,
            dayWeekLabel,
            dayWeekLabel2,
            timeLabel,
            timeLabel2,
            priceLabel,
            priceLabel2,
            placeLabel,
            placeLabel2,
            mapView
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
    private var seller: User?
    private var buyer: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        configureUI()
    }
    
    private func getUsers() {
        FirestoreManager.shared.readUser(uid: match.seller) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    self.seller = user
                    print("강사 성공")
                    FirestoreManager.shared.readUser(uid: self.match.buyer) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                            case .success(let user):
                                self.buyer = user
                                print("학생 성공")
                                self.configure()
                            case .failure(let error):
                                print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}

extension MatchConfirmViewController {
    private func configureUI() {
        configureNavBar()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        let commonInset: CGFloat = 15.0
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(commonInset)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide).inset(commonInset)
            $0.width.equalToSuperview().inset(commonInset)
        }
        
        mapView.snp.makeConstraints {
            $0.width.equalTo(stackView.snp.width)
            $0.height.equalTo(stackView.snp.width)
        }
    }
    
    private func configure() {
        sellerLabel2.text = seller?.nickName
        buyerLabel2.text = buyer?.nickName
        if let date = match.date {
            let sortedSet = date.sorted(by: {$0 < $1})
            var text = ""
            sortedSet.forEach {
                text += "\($0.description) ,"
            }
            let _ = text.removeLast(2)
            dayWeekLabel2.text = text
        }
        timeLabel2.text = match.time ?? ""
        placeLabel2.text = match.place ?? ""
        priceLabel2.text = match.price ?? ""
        if let location = match.location {
            mapView.configure(with: location)
        }
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
