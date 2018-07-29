//
//  PreviewViewController.swift
//  CustomCamera
//
//  Created by punyawee  on 29/7/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var getImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = getImage {
            imageView.image = image
        }
    }
    
    @IBAction func tappedCloseBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSaveBtn(_ sender: UIButton) {
        if let image = getImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        dismiss(animated: true, completion: nil)
    }
}
