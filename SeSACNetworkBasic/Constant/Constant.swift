//
//  Constant.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/08/01.
//

import Foundation

//enum StoryboardName: String {
//    case Main
//    case Search
//    case Setting
//}



struct StoryboardName {

    //접근제어를 통해 초기화 방지
    //아래와 같이 접근제어를 통해서 초기화를 방지하면 열거형과 같이 쓸 수 있는데 열거형을 사용하면 되는 것을 굳이 그럴 필요가 없음
    private init() {

    }

    static let main = "Main"
    static let search = "Search"
    static let setting = "Setting"
}



/*
 1. struct type property VS enum type property => 인스턴스 생성 방지
 만약 구조체로 생성하게 되면 협업에서 누군가 인스턴스를 생성할 가능성이 생기고 만약 인스턴스가 생성되면 코드의 일관성이 깨지고 불필요한 공간이 생길 수 있게 됨
 그러므로 공통된 상수를 활용할때는 열거형을 사용하는 것이 적합함
 
 2. enum case VS enum static => case로 사용하면 rawValue는 해셔블 해야되기 때문에 중복된 내용을 다른 공간에서 사용이 불가함
 그러므로 중복된 내용을 다른 공간에서 사용을 해야할 경우에는 static을 사용하는 것이 적합함
 */
//enum StoryboardName {
//    //열거형은 인스턴스를 만들지 못하기 때문에 인스턴스를 통해서 접근할 수 있는 저장 프로퍼티는 사용하지 못함
//    //var nickname = "고래밥"
//    static let main = "Main"
//    static let search = "Search"
//    static let setting = "Setting"
//}

enum FontName {
    //rawValue는 같은 값을 가질 수 없음
    static let title = "SanFransisco"
    static let body = "SanFransisco"
    static let caption = "AppleSandol"
}
