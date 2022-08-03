//
//  LottoViewController.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/07/28.
//

import UIKit

//1. 임포트
//내부 먼저 임포트 한후에 한칸 띄고 외부 라이브러리는 알파벳 순으로 정렬하는 편
import Alamofire
import SwiftyJSON

class LottoViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    
    var lottoPickerView = UIPickerView()
    //코드로 뷰를 만드는 기능이 훨씬 더 많이 남아있음
    
    @IBOutlet var lottoNumbers: [UILabel]!
    
    var numberList: [Int] = Array(1...986).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        numberTextField.textContentType = .oneTimeCode //인증번호
        
        //커서 없어진 것처럼 보이게하기
        numberTextField.tintColor = .clear
        //텍스트필드를 클릭할때 키보드 대체자 지정
        numberTextField.inputView = lottoPickerView
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        //서버가 통신될때 항상 최근 회차를 가져올 수 있게 해줌
        requestLotto(number: numberList.endIndex)
        
    }
    
    @IBAction func outOfPickerView(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
        
    }
    func requestLotto(number: Int) {
        
        //AF: 200~299 status code
        //validate에서 status code의 성공 범위를 설정해줄 수 있음(유효성 설정)
        //알라모파이어가 AF의 접두어로 사용하게 된 변경사항은 알라모파이어 라이브러리 깃헙의 리드미, issues에서 확인해볼 수 있음
        //알라모파이어6에서는 responseJSON이 deprecated 될 예정
        //지금은 일단 고려할 필요 없음
        let url = "\(EndPoint.lottoURL)&drwNo=\(number)"
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { [self] response in
            switch response.result {
                //성공케이스에 대한 설정
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let bonus = json["bnusNo"].intValue
                print(bonus)
                
                let date = json["drwNoDate"].stringValue
                print(date)
                
                let new = json["drwNo"].intValue
                print(new)
                
                self.numberTextField.text = date //클로저 안에서 텍스트필드가 명확하게 클래스 안에 있는 것을 알려줘야하기 때문에 self 키워드 사용
                
//                if new != 0 {
//
//                    for i in 1...new {
//
//                        numberList[i-1] = i
//
//                    }
//                }
                
                
                let no1 = json["drwtNo1"].intValue
                let no2 = json["drwtNo2"].intValue
                let no3 = json["drwtNo3"].intValue
                let no4 = json["drwtNo4"].intValue
                let no5 = json["drwtNo5"].intValue
                let no6 = json["drwtNo6"].intValue
                let no7 = json["bnusNo"].intValue
                
                let nums: [Int] = [no1, no2, no3, no4, no5, no6, no7]
                
                for i in 0...6 {
                    
                    lottoNumbers[i].text = String(nums[i])
                    
                }
                
                //실패케이스에 대한 설정
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //피커뷰의 선택할 수 있는 요소 갯수 설정
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //피커뷰의 요소의 선택 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLotto(number: numberList[row]) //회차에 따른 날짜를 텍스트필드에 보여줌
        
        view.endEditing(true)
        //numberTextField.text = "\(numberList[row])회차" //먼저 나오고 그 후에 덮어짐
    }
    
    //각각 열마다 어떤 글자 넣어줄것인지
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}
