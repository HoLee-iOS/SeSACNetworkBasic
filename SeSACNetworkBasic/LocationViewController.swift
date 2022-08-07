//
//  LocationViewController.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/07/29.
//

import UIKit

class LocationViewController: UIViewController {
    
    //LocationViewController.self 메타 타입 => "LocationViewController"
    @IBOutlet weak var imageView: UIImageView!
    
    //Notification
    //1. 객체 생성
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Font
        //가지고 있는 폰트가 뭐가 있는 정확하게 확인하기 위한 용도로 한번 확인해보고 지워도 됨
        //폰트네임
        //패밀리네임
        for family in UIFont.familyNames {
            print("========\(family)=========")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print(name)
            }
            
        }
         
        
        requestAuthorization()        
        
    }
    
    @IBAction func downloadImage(_ sender: UIButton) {
        
        //킹피셔를 쓰지 않는 방법
        let url = "https://apod.nasa.gov/apod/image/2208/M13_final2_sinfirma.jpg"
        print("1", Thread.isMainThread)
        
        DispatchQueue.global().async { //동시 여러 작업 가능하게 해줘!
            
            print("2", Thread.isMainThread)
            
            let data = try! Data(contentsOf: URL(string: url)!)
            let image = UIImage(data: data)
            
            //이미지뷰에 이미지를 넣는 동작은 메인스레드로 동작하게 처리해줌
            DispatchQueue.main.async {

                print("3", Thread.isMainThread)
                self.imageView.image = image
            }
        }
    }
    
    @IBAction func notificationButtonClicked(_ sender: UIButton) {
        
        sendNotification()
        
    }
    
    //Notification
    //2. 권한 요청
    //아래와 같이 private을 사용하면 다른 파일에서 사용 못하게 가능함
    private func requestAuthorization() {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            
            if success {
                self.sendNotification()
            }
            
        }
    }
    
    //Notification
    //3. 권한 허용한 사용자에게 알림 요청(언제? 어떤 컨텐츠?)
    //iOS 시스템에서 알림을 담당 > 알림 등록하는 코드도 필요
    
    /*
     - 권한 허용 해야만 알림이 온다
     - 권한 허용 문구 시스템적으로 최초 한 번만 뜬다
     - 허용 안 된 경우 애플 설정으로 직접 유도하는 코드를 구성 해야함
     
     - 기본적으로 알림은 포그라운드에서 수신되지 않음
     - 로컬 알림에서 60초 이상 반복 가능 / 갯수 제한 64개 / 커스텀 사운드 30초 제한 /
     
     1. 뱃지 제거? > 언제 제거하는 것이 맞을까? > 앱이 Active 되는 상태인 sceneDidBecomeActive 시점에 제거해주는 것이 맞음
     2. 노티 제거? > 노티의 유효기간은? > 디폴트 기간은 한달정도 > pending으로 예약된 것까지 다 삭제 가능하고 그게 아니라면 deliver로 지금까지의 것만 다 삭제
     3. 포그라운드 수신? > 델리게이트 메서드로 해결!
     
     +a
     - 노티는 앱 실행이 기본인데, 특정 노티를 클릭할 때 특정 화면으로 가고 싶다면?
     - 포그라운드 수신 > 특정 화면에서는 안받고 특정 조건에 대해서만 포그라운드 수신을 하고 싶다면?
     - iOS 집중모드 등 5~6 우선순위 존재!
     */
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "다마고치를 키워보세요"
        notificationContent.subtitle = "오늘 행운의 숫자는 \(Int.random(in: 1...100))입니다!"
        notificationContent.body = "저는 따끔따끔 다마고치입니다. 배고파요."
        notificationContent.badge = 40
        
        //언제 보낼 것인가? 1. 시간 간격 2. 캘린더 3. 위치에 따라 설정 가능
        //시간 간격은 초 기준으로 60초 이상 설정해야 반복 가능
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        var dateComponents = DateComponents()
        dateComponents.minute = 15
        //매시간의 15분이 되면 알람이 옴
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //알림 요청
        //identifier:
        //만약 알림 관리 할 필요 X -> 알림 클릭하면 앱을 켜주는 정도
        //만약 알림 관리 할 필요 O -> +1, 고유 이름, 규칙 등
        //12개 >
        //앱들의 id를 Date로
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request)
        
    }
    
    
}
