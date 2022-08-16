//
//  EnrollPlaceCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollPlaceCellDelegate: AnyObject {
    func passData(place: String?, location: Location?)
    func presentFromPlaceCell(viewController: UIViewController)
}

class EnrollPlaceCell: UITableViewCell {

    // MARK: - Views

    private lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업장소 미지정시 현재 위치로 저장됩니다")
        textField.rightView = button
        textField.rightViewMode = .always
        textField.delegate = self
        return textField
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "map"), for: .normal)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(selectPlace(_:)), for: .touchDown)
        return button
    }()

    // MARK: - Properties

    static let identifier = "EnrollPlaceCell"
    weak var delegate: EnrollPlaceCellDelegate?
    private var location: Location?

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func configureUI() {
        contentView.addSubview(placeTextField)
        placeTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.bottom.equalToSuperview()
        }
    }

    func setUnderline() {
        placeTextField.setUnderLine()
    }

    func configureWith(place: String?, location: Location?) {
        guard let place = place, let location = location else {
            return
        }
        placeTextField.text = place
        self.location = location
    }

    // MARK: - Actions

    @objc func selectPlace(_ button: UIButton) {
        let mapSelectionViewController = MapSelectionViewController()
        mapSelectionViewController.configure(location: location)
        mapSelectionViewController.delegate = self
        delegate?.presentFromPlaceCell(viewController: mapSelectionViewController)
    }
}

// MARK: - UITextFieldDelegate

extension EnrollPlaceCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

    /// 텍스트 필드 입력 수정 방지
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension EnrollPlaceCell: MapSelectionViewControllerDelegate {
    func isLocationSelected(location: Location?, place: String?) {
        self.placeTextField.text = place ?? nil
        guard let location = location else {
            self.location = LocationManager.shared.getCurrentLocation()
            delegate?.passData(place: place, location: self.location)
            return
        }
        self.location = location
        delegate?.passData(place: place, location: location)
    }
}
