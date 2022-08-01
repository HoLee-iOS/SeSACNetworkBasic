//
//  UserDefaultsHelper.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/08/01.
//

import UIKit

class UserDefaultsHelper {
    
    //인스턴스를 내부에서만 사용할 수 있게 접근 제어까지 걸어주면 완전하게 싱글톤 패턴으로 활용 가능
    private init() { }
    
    //singleton pattern: 자기 자신의 인스턴스를 타입 프로퍼티 형태로 가지고 있음
    static let standard = UserDefaultsHelper() //내가 만든 싱글톤패턴
    
    let userDefaults = UserDefaults.standard //애플이 내부적으로 만들어놓은 싱글톤 패턴
    
    enum Key: String {
        case nickname, age
    }
    
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set { //연산 프로퍼티 parameter
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
    
    
}
