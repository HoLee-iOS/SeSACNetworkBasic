//
//  ImageSearchViewController.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class ImageSearchViewController: UIViewController {
    
    @IBOutlet weak var imageSearchCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var images: [String] = []
    
    //네트워크 요청시 시작 페이지 넘버
    var startPage = 1
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: ImageSearchCollectionViewCell.resuseIdentifier, bundle: nil)
        imageSearchCollectionView.register(nibName, forCellWithReuseIdentifier: ImageSearchCollectionViewCell.resuseIdentifier)
        
        imageSearchCollectionView.delegate = self
        imageSearchCollectionView.dataSource = self
        //2. 해당 뷰에 추가해줌
        imageSearchCollectionView.prefetchDataSource = self //페이지네이션
        
        searchBar.delegate = self
        
        //컬렉션뷰의 셀 크기, 셀 간격 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 4)
        layout.itemSize = CGSize(width: width / 3, height: width / 3 * 1.2) //init과 같음
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        //위에서 설정한 속성 값을 컬렉션뷰에 할당해줌
        imageSearchCollectionView.collectionViewLayout = layout
        
    }
    
    //fetchImage, requestImage, callRequestImage, getImage... > response에 따라 네이밍을 설정해주기도 함.
    func fetchImage(query: String) {
        //쿼리는 한글이 들어가면 에러가 남, 딕셔너리처럼 순서는 상관 없음
        //한글을 사용하지 못하는 이유는 한글이 utf-8로 인코딩되지 않았기 때문
        //아래와 같은 코드로 인코딩 처리가 가능함
        ImageSearchAPIManager.shared.fetchImageData(query: query, startPage: startPage) { totalCount, images in
            self.totalCount = totalCount
            self.images.append(contentsOf: images)
            
            DispatchQueue.main.async {
                self.imageSearchCollectionView.reloadData()
            }
            
        }//클로저 구문에서는 값을 빼옴
        
    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    
    //검색 버튼 클릭 시 실행, 키보드 리턴키에 디폴트로 구현됨
    //검색 단어가 바뀔 수 있음
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        
        //이름 같으면 가까운 친구 갖고 옴
        if let text = searchBar.text {
            //배열에 기존의 정보에 대한 데이터가 남아있기 때문에 지우고 다시 1페이지부터 보여줘야함
            images.removeAll()
            startPage = 1
            //imageSearchCollectionView.scrollToItem(at: <#T##IndexPath#>, at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
            
            fetchImage(query: text)
            
        }
        
    }
    
    //취소 버튼 눌렀을때 실행
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        images.removeAll()
        imageSearchCollectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //서치바에 커서가 깜빡이기 시작할 때 실행
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}


//페이지네이션 방법 3.
//용량이 큰 이미지를 다운받아서 셀에 보여주려고 하는 경우에 효과적.
//화면에 셀이 보이기 전에 다운 받을 수도 있고 다운 받으려고 했는데 필요가 없다면 취소하려는 것도 가능하기 때문
//iOS10 이상부터 사용을 할 수 있음, 해당 기능을 사용하면 스크롤의 성능이 향상됨(느끼기는 좀 어려움)
//1. prefetching extension 해줌
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    
    //셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        //인덱스의 갯수와 이미지 배열의 갯수가 같아지면 == 처음에 디스플레이 해준 아이템들을 다 보여주면
        //다시 startpage에 30을 더해주면서 뒤에 30개의 아이템을 또 추가해주면서 새로운 아이템들을 계속 보여줄 수 있음
        for indexPath in indexPaths {
            if images.count - 1 == indexPath.item && images.count < totalCount {
                print(indexPath.item)
                startPage += 30
                fetchImage(query: searchBar.text!)
            }
        }
        
        print("===\(indexPaths)")
    }
    
    //취소: 직접 취소하는 기능을 구현해야함
    //예를 들어 사용자가 만약 너무 빠르게 스크롤을 내린다면 리소스 다운 받는 것을 취소할때
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===취소: \(indexPaths)")
    }
    
}




extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.resuseIdentifier, for: indexPath) as! ImageSearchCollectionViewCell
        
        
        cell.searchImage.kf.setImage(with: URL(string: images[indexPath.row]))
        
        
        return cell
    }
    
    //페이지네이션 방법 1. 컬렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    //마지막 셀에 사용자가 위치해있는지 명확하게 확인하기가 어려움
    //위와 같은 문제점 때문에 굳이 페이지네이션이 필요없을 수 있는데 여러번 네트워크 통신이 될 수 있어서 권장하지 않음
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
    //페이지네이션 방법 2. UIScrollViewDelegateProtocol
    //테이블뷰 / 컬렉션뷰 스크롤뷰를 상속받고 있어서, 스크롤뷰 프로토콜을 사용할 수 있음
    //scrollView.contentSize.height
    //스크롤을 할때마다 계속 실행이 됨
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y) //스크롤뷰의 가장 끝 시점을 의미하며 y를 이용하면 전체 스크롤에서 지금 나의 스크롤뷰의 끝 시점은 어디인지 확인 가능
//    }
    
}
