//
//  ImagePicker.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/30.
//

import UIKit
import MobileCoreServices

class ImagePicker: NSObject {

    class func cameraPhoto(_ viewController: UIViewController, edit: Bool) {

        let type = kUTTypeImage as String

        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                if (availableMediaTypes.contains(type)) {

                    let imagePicker = UIImagePickerController()
                    imagePicker.mediaTypes = [type]
                    imagePicker.sourceType = .camera

                    if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
                        imagePicker.cameraDevice = .rear
                    } else if (UIImagePickerController.isCameraDeviceAvailable(.front)) {
                        imagePicker.cameraDevice = .front
                    }

                    imagePicker.allowsEditing = edit
                    imagePicker.showsCameraControls = true
                    imagePicker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                    viewController.present(imagePicker, animated: true)
                }
            }
        }
    }

    class func cameraVideo(_ viewController: UIViewController, edit: Bool) {

        let type = kUTTypeMovie as String

        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                if (availableMediaTypes.contains(type)) {

                    let imagePicker = UIImagePickerController()
                    imagePicker.mediaTypes = [type]
                    imagePicker.sourceType = .camera
                    imagePicker.videoMaximumDuration = App.MaxVideoDuration

                    if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
                        imagePicker.cameraDevice = .rear
                    } else if (UIImagePickerController.isCameraDeviceAvailable(.front)) {
                        imagePicker.cameraDevice = .front
                    }

                    imagePicker.allowsEditing = edit
                    imagePicker.showsCameraControls = true
                    imagePicker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                    viewController.present(imagePicker, animated: true)
                }
            }
        }
    }

    class func cameraMulti(_ viewController: UIViewController, edit: Bool) {

        let type1 = kUTTypeImage as String
        let type2 = kUTTypeMovie as String

        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                if (availableMediaTypes.contains(type1) && availableMediaTypes.contains(type2)) {

                    let imagePicker = UIImagePickerController()
                    imagePicker.mediaTypes = [type1, type2]
                    imagePicker.sourceType = .camera
                    imagePicker.videoMaximumDuration = App.MaxVideoDuration

                    if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
                        imagePicker.cameraDevice = .rear
                    } else if (UIImagePickerController.isCameraDeviceAvailable(.front)) {
                        imagePicker.cameraDevice = .front
                    }

                    imagePicker.allowsEditing = edit
                    imagePicker.showsCameraControls = true
                    imagePicker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                    viewController.present(imagePicker, animated: true)
                }
            }
        }
    }

    class func photoLibrary(_ viewController: UIViewController, edit: Bool) {

        let type = kUTTypeImage as String

        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if (availableMediaTypes.contains(type)) {

                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.mediaTypes = [type]

                    imagePicker.allowsEditing = edit
                    imagePicker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                    viewController.present(imagePicker, animated: true)
                }
            }
        }
        else if (UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)) {
            if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if (availableMediaTypes.contains(type)) {

                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.mediaTypes = [type]

                    imagePicker.allowsEditing = edit
                    imagePicker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                    viewController.present(imagePicker, animated: true)
                }
            }
        }
    }

    class func videoLibrary(_ viewController: UIViewController, edit: Bool) {

        let type = kUTTypeMovie as String

        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if (availableMediaTypes.contains(type)) {

                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.mediaTypes = [type]
                    imagePicker.videoMaximumDuration = App.MaxVideoDuration

                    imagePicker.allowsEditing = edit
                    imagePicker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                    viewController.present(imagePicker, animated: true)
                }
            }
        }
        else if (UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)) {
            if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if (availableMediaTypes.contains(type)) {

                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.mediaTypes = [type]
                    imagePicker.videoMaximumDuration = App.MaxVideoDuration

                    imagePicker.allowsEditing = edit
                    imagePicker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                    viewController.present(imagePicker, animated: true)
                }
            }
        }
    }
}
