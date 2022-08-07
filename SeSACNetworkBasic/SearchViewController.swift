//
//  SearchViewController.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/07/27.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

/*
 Swift Protocol
 - Delegate
 - Datasource
 
 1. 왼팔/오른팔
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2
 */

/*
 
 각 json
 
 let movieNm1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
 let movieNm2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
 let movieNm3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
 
 list 배열에 데이터 추가
 self.list.append(movieNm1)
 self.list.append(movieNm2)
 self.list.append(movieNm3)
 
 */



extension UIViewController {
    
    func setBackgroundColor() {
        view.backgroundColor = .red
    }
    
}


// 테이블뷰의 메서드를 가져와서 사용하기 위해서는 아래와 같이 delegate와 datasource를 상속 받아와야함
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //로딩뷰 객체 ProgressView
    let hud = JGProgressHUD()
    
    //BoxOffice 배열
    var list: [BoxOfficeModel] = []
    
    //타입 어노테이션 VS 타입 추론 => 누가 더 속도가 빠를까
    //애플 내부의 타입추론에 대한 알고리즘의 발전으로 타입추론이 더 빠를것임
    //What's new in swift
    var nickname: String = ""
    var username = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
//        view.backgroundColor = .red
        searchTableView.backgroundColor = .clear
        //연결고리 작업: 테이블뷰가 해야 할 역할 > 뷰 컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        //테이블뷰가 사용할 테이블뷰 셀(XIB) 등록
        //XIB: xml interface builder <= NIB
        searchTableView.register(UINib(nibName: ListTableViewCell.resuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.resuseIdentifier)
        
        //데이트 형태 설정
        //Date, DateFormatter, Calendar 용도 정리해보기
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        
        //데이트의 타임 인터벌을 이용해서 어제 날짜 계산
        //let dateResult = Date(timeIntervalSinceNow: -86400)
        
        //adding: 기준 단위, to: 기준 날짜, value: 값
        //to에서 adding * value 만큼 이동한 날짜로 계산한 값 리턴
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateResult = format.string(from: yesterday!)
        
        //네트워크 통신: 서버 점검 등에 대한 예외 처리
        //네트워크가 느린 환경 테스트
        //실기기 테스트시 Condition 조절 가능!
        //시뮬레이터에서도 가능! (추가 설치)
        
        
        requestBoxOffice(text: dateResult)
        
    }
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        
    }
    
    func requestBoxOffice(text: String) {
        
        //네트워크 통신 전에 로딩뷰 띄우기
        hud.show(in: view, animated: true)
        hud.textLabel.text = "Loading"
        
        self.list.removeAll()
        
        //인증키 제한
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
                //성공케이스에 대한 설정
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    
                    let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, audiAcc: audiAcc)
                    
                    self.list.append(data)
                    
                }
                
                print(self.list)
                
                //테이블뷰 갱신
                self.searchTableView.reloadData()
                
                //테이블뷰 갱신 시점에서 로딩뷰 사라지기 처리 해주면 됨
                self.hud.dismiss()
                
                print(self.list)
                
                
                //실패케이스에 대한 설정
            case .failure(let error):
                print(error)
                
                //통신 실패시에도 로딩뷰에 대한 처리를 해줘야함
                self.searchTableView.reloadData()
                self.hud.dismiss()
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.resuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle) : \(list[indexPath.row].releaseDate)"
        
        return cell
        
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text!) //옵셔널 바인딩, 8글자, 숫자, 날짜로 변경 시 유효한 형태의 값인지
    }
    
}
