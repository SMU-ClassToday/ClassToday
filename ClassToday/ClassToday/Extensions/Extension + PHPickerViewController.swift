//
//  Extension + PHPickerViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/22.
//

import PhotosUI

//MARK: PHPickerViewController 생성 함수
extension PHPickerViewController {
    static func makeImagePicker(selectLimit: Int) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = selectLimit
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }
}
