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
    private lazy var starImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = starColor
        return imageView
    }()
    private lazy var starImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = starColor
        return imageView
    }()
    private lazy var starImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = starColor
        return imageView
    }()
    private lazy var starImageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = starColor
        return imageView
    }()
    private lazy var starImageView5: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = starColor
        return imageView
    }()
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
    let grade: Double
    
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

private extension GradeStarView {
    func updateStars(grade: Double) {
        switch grade {
        case (0.0..<1.0):
            break
        case (1.0..<2.0):
            starImageView1.image = UIImage(systemName: "star.fill")
        case (2.0..<3.0):
            starImageView1.image = UIImage(systemName: "star.fill")
            starImageView2.image = UIImage(systemName: "star.fill")
        case (3.0..<4.0):
            starImageView1.image = UIImage(systemName: "star.fill")
            starImageView2.image = UIImage(systemName: "star.fill")
            starImageView3.image = UIImage(systemName: "star.fill")
        case (4.0..<5.0):
            starImageView1.image = UIImage(systemName: "star.fill")
            starImageView2.image = UIImage(systemName: "star.fill")
            starImageView3.image = UIImage(systemName: "star.fill")
            starImageView4.image = UIImage(systemName: "star.fill")
        case (5.0...):
            starImageView1.image = UIImage(systemName: "star.fill")
            starImageView2.image = UIImage(systemName: "star.fill")
            starImageView3.image = UIImage(systemName: "star.fill")
            starImageView4.image = UIImage(systemName: "star.fill")
            starImageView5.image = UIImage(systemName: "star.fill")
        default:
            break
        }
    }
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
