//
//  ListTableViewCell.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/07/27.
//

import UIKit

//익스텐션으로 UITableViewCell에 reuseIdentifier를 추가해줬기 따로 코드 없이 자동으로 추가되기 때문에 모든 화면에서 반복되는 코드 생략 가능
class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
}
