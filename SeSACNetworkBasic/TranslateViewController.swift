//
//  TranslateViewController.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/07/28.
//

import UIKit

//컨트롤에 기반
//UIButton, UITextField > Action
//UITextView, UISearchBar, UIPickerView > X
//UIControl
//UIResponderChain > resignFirstResponder() / becomeFirstResponder() > 내일

class TranslateViewController: UIViewController {

    @IBOutlet weak var userInputTextView: UITextView!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 작성해보세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //델리게이트 연결
        userInputTextView.delegate = self
        
        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .lightGray
        
        userInputTextView.font = UIFont(name: "OKCHAN", size: 17) //폰트를 만들때 맞춤법에 맞지 않는 글자들은 다 지움
        
    }
    
}

extension TranslateViewController: UITextViewDelegate {
    
    //텍스트뷰의 텍스트가 변할 때마다 호출
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
    }
    
    //편집이 시작될 때. 커서가 시작될 때 호출
    //텍스트뷰 글자: 플레이스 홀더랑 글자가 같으면 clear
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Begin")
        
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
        
    }
    
    //편집이 끝났을 때. 커서가 없어지는 순간
    //텍스트뷰 글자: 글씨가 하나도 없으면 플레이스 홀더 글자를 보이게하라
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End")
        
        if textView.text.isEmpty {
            textView.textColor = .lightGray
            textView.text = textViewPlaceholderText
        }
        
    }
    
}
