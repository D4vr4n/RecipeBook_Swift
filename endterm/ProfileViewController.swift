//
//  ProfileViewController.swift
//  endterm
//
//  Created by Davran Arifzhanov on 08.12.2020.
//

import UIKit
import Firebase


public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}
//MARK -- ImagePicker
open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
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
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}


class ProfileViewController: UIViewController, ImagePickerDelegate {
   
    func didSelect(image: UIImage?) {
        self.avatarView.image = image
    }
    
     
    var user: User!
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountLabel.text = Auth.auth().currentUser?.email
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        avatarView?.layer.cornerRadius = (avatarView?.frame.size.width ?? 0.0) / 2
        avatarView?.clipsToBounds = true
        avatarView?.layer.borderWidth = 3.0
        avatarView?.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBAction func pickImageTapped(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    @IBAction func signOutDidTapped(_ sender: Any) {

        let user = Auth.auth().currentUser!
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")

        onlineRef.removeValue { (error, _) in

          if let error = error {
            print("Removing online failed: \(error)")
            return
          }

          do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
          } catch (let error) {
            print("Auth sign out failed: \(error)")
          }
        }
    }
    
}
