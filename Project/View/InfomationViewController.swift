//
//  InfomationViewController.swift
//  Project
//
//  Created by geotech on 01/07/2021.
//

import UIKit
import MessageUI
import Alamofire
import SVProgressHUD
class InfomationViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var personData:PersonHolder!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var emailTxtView: UITextView!
    @IBOutlet weak var fullNameTxtView: UITextView!
    @IBOutlet weak var idTxtView: UITextView!
    @IBAction func sendEmailBtnPressed(_ sender: Any) {
        if (MFMailComposeViewController.canSendMail()){
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([personData.email])
            mail.setSubject("Greating Mail")
            mail.setMessageBody("<p>Hello, my name is \(personData.firstName) \(personData.lastName)<p>", isHTML: true)
        }
       
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Loading...")
        guard let url = URL(string: personData.avatar) else {return}
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            if error == nil{
                DispatchQueue.main.async {
                    self.pictureImageView.image = UIImage(data: data!)
                }
                SVProgressHUD.dismiss()
            }
        }
        task.resume()
    
        idTxtView.text = String(describing: personData.id)
        emailTxtView.text = personData.email
        fullNameTxtView.text = personData.firstName + " " + personData.lastName
    }
    
   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

