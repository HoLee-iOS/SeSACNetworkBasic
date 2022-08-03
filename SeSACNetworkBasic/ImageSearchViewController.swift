//
//  ImageSearchViewController.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class ImageSearchViewController: UIViewController {
    
    @IBOutlet weak var imageSearchCollectionView: UICollectionView!
    
    var images: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: ImageSearchCollectionViewCell.resuseIdentifier, bundle: nil)
        imageSearchCollectionView.register(nibName, forCellWithReuseIdentifier: ImageSearchCollectionViewCell.resuseIdentifier)
        
        imageSearchCollectionView.delegate = self
        imageSearchCollectionView.dataSource = self
        
        //컬렉션뷰의 셀 크기, 셀 간격 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.itemSize = CGSize(width: width , height: width * 1.2 ) //init과 같음
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        //위에서 설정한 속성 값을 컬렉션뷰에 할당해줌
        imageSearchCollectionView.collectionViewLayout = layout
        
        fetchImage()
    }
    
    //fetchImage, requestImage, callRequestImage, getImage... > response에 따라 네이밍을 설정해주기도 함.
    func fetchImage() {
        //쿼리는 한글이 들어가면 에러가 남, 딕셔너리처럼 순서는 상관 없음
        //한글을 사용하지 못하는 이유는 한글이 utf-8로 인코딩되지 않았기 때문
        //아래와 같은 코드로 인코딩 처리가 가능함
        let text = "치킨".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=31"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for i in json["items"].arrayValue {
                    
                    guard let x = i["thumbnail"].url else { return }
                    self.images.append(x)
                }
                
                
                self.imageSearchCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
}

extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.resuseIdentifier, for: indexPath) as! ImageSearchCollectionViewCell
        
        
        cell.searchImage.kf.setImage(with: images[indexPath.row])
        
        
        return cell
    }
    
}
