//
//  LottoViewController.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/07/28.
//

import UIKit

class LottoViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    
    var lottoPickerView = UIPickerView()
    //코드로 뷰를 만드는 기능이 훨씬 더 많이 남아있음
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        numberTextField.textContentType = .oneTimeCode //인증번호
        
        //커서 없어진 것처럼 보이게하기
        numberTextField.tintColor = .clear
        //텍스트필드를 클릭할때 키보드 대체자 지정
        numberTextField.inputView = lottoPickerView
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
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
        numberTextField.text = "\(numberList[row])회차"
    }
    
    //각각 열마다 어떤 글자 넣어줄것인지
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}
