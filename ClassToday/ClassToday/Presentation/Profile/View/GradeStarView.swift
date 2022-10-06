//
//  GradeStarView.swift
//  ClassToday
//
//  Created by yc on 2022/05/07.
//

import UIKit
import SnapKit

class GradeStarView: UIView {
    
    // MARK: - UI Components
    private let starColor: UIColor = .systemYellow
    private lazy var starImageView1 = UIImageView().starImageView
    private lazy var starImageView2 = UIImageView().starImageView
    private lazy var starImageView3 = UIImageView().starImageView
    private lazy var starImageView4 = UIImageView().starImageView
    private lazy var starImageView5 = UIImageView().starImageView
    private lazy var starImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8.0
        return stackView
    }()
    private lazy var gradeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(String(format: "%.2f", grade))"
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        return label
    }()
    
    // MARK: - Properties
    private let grade: Double
    
    // MARK: - init
    init(grade: Double) {
        self.grade = grade
        super.init(frame: .zero)
        layout()
        updateStars(grade: grade)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GradeStarView {
    func updateStars(grade: Double) {
        switch grade {
        case (0.0..<1.0):
            if grade == 0.5 {
                starImageView1.image = Icon.halfStar.image
            } else {
                starImageView1.image = Icon.star.image
            }
            starImageView2.image = Icon.star.image
            starImageView3.image = Icon.star.image
            starImageView4.image = Icon.star.image
            starImageView5.image = Icon.star.image
        case (1.0..<2.0):
            starImageView1.image = Icon.fillStar.image
            if grade == 1.5 {
                starImageView2.image = Icon.halfStar.image
            } else {
                starImageView2.image = Icon.star.image
            }
            starImageView3.image = Icon.star.image
            starImageView4.image = Icon.star.image
            starImageView5.image = Icon.star.image
        case (2.0..<3.0):
            starImageView1.image = Icon.fillStar.image
            starImageView2.image = Icon.fillStar.image
            if grade == 2.5 {
                starImageView3.image = Icon.halfStar.image
            } else {
                starImageView3.image = Icon.star.image
            }
            starImageView4.image = Icon.star.image
            starImageView5.image = Icon.star.image
        case (3.0..<4.0):
            starImageView1.image = Icon.fillStar.image
            starImageView2.image = Icon.fillStar.image
            starImageView3.image = Icon.fillStar.image
            if grade == 3.5 {
                starImageView4.image = Icon.halfStar.image
            } else {
                starImageView4.image = Icon.star.image
            }
            starImageView5.image = Icon.star.image
        case (4.0..<5.0):
            starImageView1.image = Icon.fillStar.image
            starImageView2.image = Icon.fillStar.image
            starImageView3.image = Icon.fillStar.image
            starImageView4.image = Icon.fillStar.image
            if grade == 4.5 {
                starImageView5.image = Icon.halfStar.image
            } else {
                starImageView5.image = Icon.star.image
            }
        case (5.0...):
            starImageView1.image = Icon.fillStar.image
            starImageView2.image = Icon.fillStar.image
            starImageView3.image = Icon.fillStar.image
            starImageView4.image = Icon.fillStar.image
            starImageView5.image = Icon.fillStar.image
        default:
            break
        }
        gradeLabel.text = "\(grade)"
    }
}

private extension GradeStarView {
    func layout() {
        [
            starImageView1,
            starImageView2,
            starImageView3,
            starImageView4,
            starImageView5
        ].forEach { button in
            button.snp.makeConstraints {
                $0.size.equalTo(36.0)
            }
            starImageStackView.addArrangedSubview(button)
        }
        [
            starImageStackView,
            gradeLabel
        ].forEach { addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        starImageStackView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        gradeLabel.snp.makeConstraints {
            $0.leading.equalTo(starImageStackView.snp.trailing).offset(commonInset)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.bottom.equalTo(starImageStackView.snp.bottom)
        }
    }
}
