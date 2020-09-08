//
//  ImageUtility.swift
//  High Strangeness
//
//  Created by penguindrum on 9/7/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import UIKit

public protocol ImageUtilityDelegate {
    func getSelectedImage(image: UIImage?)
}

open class ImageUtility: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private let imagePickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private var delegate: ImageUtilityDelegate?

    public init(viewController: UIViewController, delegate: ImageUtilityDelegate) {
        self.imagePickerController = UIImagePickerController()
        super.init()

        self.presentationController = viewController
        self.delegate = delegate
        
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.mediaTypes = ["public.image"]
    }

    //perform action based on action type
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.imagePickerController.sourceType = type
            self.presentationController?.present(self.imagePickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        self.delegate?.getSelectedImage(image: image)
        controller.dismiss(animated: true, completion: nil)
    }
}
