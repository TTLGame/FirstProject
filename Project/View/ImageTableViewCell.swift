//
//  ImageTableViewCell.swift
//  Project
//
//  Created by geotech on 01/07/2021.
//

import UIKit
import SDWebImage
class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var idTxtView: UITextView!
    @IBOutlet weak var firstNameTxtView: UITextView!
    @IBOutlet weak var lastNameTxtView: UITextView!
    override func prepareForReuse() {
        super.prepareForReuse()
        idTxtView.text.removeAll()
        firstNameTxtView.text.removeAll()
        lastNameTxtView.text.removeAll()
        pictureImageView.image = UIImage(named: "LoadingImage")
    }
    // func Load ImgURL for Image Table View
    func loadImgViewURL(with personData:PersonHolder) throws -> URL{
        guard let url = URL(string: personData.avatar) else {
            throw ReadError.invalidURL
        }
        return url
    }
    
    func populateCell(with personData:PersonHolder){
        //loading lazy image
        do {
            let imageURL = try loadImgViewURL(with: personData)
            pictureImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "LoadingImage"))
        } catch ReadError.invalidURL {
            print("Cannot read URL")}
        catch {
            print("ERROR")}
        //load infomation
        firstNameTxtView.text = personData.firstName
        lastNameTxtView.text = personData.lastName
        idTxtView.text = String(describing: personData.id)
        idTxtView.isScrollEnabled = false
        lastNameTxtView.isScrollEnabled = false
        firstNameTxtView.isScrollEnabled = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension UITableViewCell{
    static var identifier: String{
        return String(describing: self)
    }
}

//let imageCache = NSCache<AnyObject, UIImage>()
//extension UIImageView{
//
//    func loadImage(imageURL: URL,placeholder: String){
//        self.image = UIImage(named: placeholder)
//        if let cachdImage = imageCache.object(forKey: imageURL as AnyObject){
//            self.image = cachdImage
//            return
//        }
//        DispatchQueue.global().async {
//            [weak self] in
//            if let imageData = try? Data(contentsOf: imageURL){
//                if let image = UIImage(data: imageData){
//                    DispatchQueue.main.async {
//                        imageCache.setObject(image, forKey: imageURL as AnyObject)
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}
