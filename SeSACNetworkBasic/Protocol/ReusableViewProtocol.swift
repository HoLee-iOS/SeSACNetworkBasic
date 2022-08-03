//
//  ReusableViewProtocol.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/08/01.
//

import UIKit

protocol ReusableViewProtocol {
    static var resuseIdentifier: String { get }
}

extension UIViewController: ReusableViewProtocol { //extension 저장 프로퍼티 불가능
    
    //UIViewController를 상속 받은 모든 컨트롤러에서는 인제 자동으로 identifier라는 연산프로퍼티가 생성되기 때문에 따로 복붙해서 사용할 필요 없이 바로 사용 가능함
    static var resuseIdentifier: String { //연산 프로퍼티 get만 사용한다면 get 생략 가능
            return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableViewProtocol {
    
    static var resuseIdentifier: String{
        return String(describing: self)
    }
    
}

extension UICollectionViewCell: ReusableViewProtocol {
    
    static var resuseIdentifier: String {
        return String(describing: self)
    }
    
}
