//
//  ImageCollectionViewCell.swift
//  Project
//
//  Created by geotech on 05/08/2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    //Outlet variable
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var idTxtView: UITextView!
    @IBOutlet weak var fullNameTxtView: UITextView!
    
    //Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        pictureImageView.image = UIImage(named: "LoadingImage")
        idTxtView.text.removeAll()
        fullNameTxtView.text.removeAll()
    }
    
    //Func Load image from url
    func loadImgViewURL(with personData:PersonHolder) throws -> URL{
        guard let url = URL(string: personData.avatar) else {
            throw ReadError.invalidURL
        }
        return url
    }
    
    //configure the cell
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
        fullNameTxtView.text = personData.firstName + " " + personData.lastName
        idTxtView.text = String(describing: personData.id)
    }
}
extension UICollectionViewCell{
    static var identifier: String{
        return String(describing: self)
    }
}
