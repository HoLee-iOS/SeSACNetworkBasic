//
//  BeerViewController.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/08/01.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class BeerViewController: UIViewController {
    
    
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var randomButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerName.textColor = .black
        beerDescription.textColor = .black
        beerDescription.numberOfLines = 0
        
        randomButton.setTitle("오늘의 맥주는 뭘까용", for: .normal)
        randomButton.setTitleColor(.black, for: .normal)
        
        requestBeer()
        
    }
    
    func requestBeer() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate().responseJSON { [self] response in
            switch response.result{
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                
                let name = json[0]["name"].stringValue
                beerName.text = name
                
                let image = json[0]["image_url"].url
                if image != nil {
                    beerImage.kf.setImage(with: image)
                } else {
                    
                }
                
                let description = json[0]["description"].stringValue
                beerDescription.text = description
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @IBAction func randomBeerButtonClicked(_ sender: UIButton) {
        
        requestBeer()
        
    }
    
}

