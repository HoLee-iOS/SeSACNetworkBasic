//
//  Constant.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/08/01.
//

import Foundation

//이런식으로 키값을 따로 관리한다면 깃헙에 푸쉬할때 해당 파일을 빼고 푸쉬한다면 키값을 못보게 할 수 있음
struct APIKey {
    //프로퍼티의 모든 이름을 대문자나 소문자로 표현하면 중요도 명시 가능
    static let BOXOFFICE = "776d438f33750b3677256948f891dab5"
    
    static let NAVER_ID = "0d3qC_zWAffwQvIXmONe"
    static let NAVER_SECRET = "4NCPw0kB9A"
}

struct EndPoint {
    static let boxOfficeURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    static let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
    static let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
    //뒤에 있는 쿼리는 앱에 따라 정보를 다르게 설정할 가능성이 있기 때문에 공통적인 부분만 여기서 다뤄주고 쿼리문에 대한 정보는 뷰컨에서 상세적으로 표현해서 사용해줌
    static let imageSearchURL = "https://openapi.naver.com/v1/search/image.json?"
}


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
