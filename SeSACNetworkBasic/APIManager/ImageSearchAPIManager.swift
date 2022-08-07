//
//  ImageSearchAPIManager.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

//클래스 싱글턴 패턴 vs 구조체 싱글턴 패턴
//구조체는 싱글턴 사용안함 why?
class ImageSearchAPIManager {
    
    static let shared = ImageSearchAPIManager()
    
    private init() { }
    
    typealias completionHandler = (Int, [String]) -> Void
    
    //escaping 키워드를 통해 밖에서 사용할 것이라는 것을 명시해주면 오류 해결 가능
    func fetchImageData(query: String, startPage: Int, completionHandler: @escaping completionHandler) {
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=\(startPage)"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        //아래와 같은 요소를 글로벌로 전환해줘야함
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                //셀에서 URL, UIImage 변환을 할 것인지
                //서버통신 받는 시점에서 URL, UIImage 변환을 할 것인지 => 시간 오래 걸림
                //서버통신 시점에서는 최대한 가져올 데이터만 빠르게 가져오고 셀에서 가져온 데이터를 이용해서 처리해주는 것이 맞음
                //서버통신 시점에서 한번에 다 처리하려고 하면 만약 파일이 클 때 반복문이나 코드가 셀에서 하는 것에 비해서 좀 느리게 돌아가면
                //사용자의 입장에서 좀 느리게 로드되는 것으로 보일 수 있기 때문
                
                let totalCount = json["total"].intValue
                                
                
//                for i in json["items"].arrayValue {
//
//                    guard let x = i["thumbnail"].url else { return }
//                    self.images.append(x)
//                }
                
                //고차함수를 통한 코드 개선
                let images = json["items"].arrayValue.map { $0["link"].stringValue }
                
                completionHandler(totalCount, images)
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
}
