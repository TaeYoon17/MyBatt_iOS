
<img src="https://github.com/TaeYoon17/MyBatt_iOS/assets/46375289/aab29552-cb09-47e7-8e82-9d69c563b557.png" width="80" height="80"/><br>
# 내 밭을 부탁해
> [!NOTE]
> 작물 병해 진단의 어려움를 해결하기 위한 서비스입니다.
> 병해 검출과 주변 병해 정보, 병해 대처법 제공, 작물 관리를 도와주는 앱입니다.
#### [서비스 설명 영상](https://youtu.be/RTHg8laviaM?feature=shared)
## 주요 사용 기술
#### iOS 타겟 버전 - 15.1
+ SwiftUI, Combine
+ MVVM, Singleton
+ AVFoundation, PhotoKit
+ MapKit / *KakaoMap(버전 1.0 마커 SwiftUI 미지원으로 사용 취소)*
+ Alamofire, URLSession
## 주요 기능
#### 회원 가입 및 로그인
<img src="https://github.com/TaeYoon17/MyBatt_iOS/assets/46375289/e8fedd47-36df-469d-8abc-2ebca2fd69a3.png" width="600"/><br>
#### 병해진단 
<img src="https://github.com/TaeYoon17/MyBatt_iOS/assets/46375289/9ef77554-ef91-4118-a0c4-911267d57c65.png" width="800"/><br>
## 핵심 기능 구현
### 1. SwiftUI로 1:1 비율 카메라 촬영기능
> [!IMPORTANT]
> AVFoundation과 Concurrency 이용한 SwiftUI 카메라 기능
<img src="https://github.com/TaeYoon17/MyBatt_iOS/assets/46375289/cc236127-53b7-4ba6-bd7c-c23b07beaa53.gif" style="width:200px">
</img><br><br>

#### 아이폰 카메라 프리뷰 기능
+ 아이폰 카메라 프리뷰 기능은 실제로 디바이스 카메라에 Video기능을 이용해서 구현함
+ 매 프레임마다 **AVCaptureVideoDataOutputSampleBufferDelegate**의 captureOutput메서드를 통해 현재 카메라에 담긴 CMSampleBuffer를 가져옴
+ 해당 버퍼에 담긴 내용을 CIImage로 변환 후, 1:1 비율에 맞게 자른다.
#### 아이폰 촬영 기능
+ 아이폰 촬영 기능은 디바이스 카메라에 Capture기능을 이용해서 구현함
+ 촬영 request 후, **AVCapturePhotoCaptureDelegate**의 photoOutput을 통해 AVCapturePhoto 정보를 가져옴
+ AVCaputrePhoto는 이미지의 메타 데이터 등, 위에서 받는 CMSampleBuffer 보다 여러 정보를 포함함

### 3. iOS 15.1 SwiftUI goToRootView 기능
> [!IMPORTANT]
> NavigationView 컴포넌트에서 미지원하는 루트뷰로 바로 이동하는 기능
+ 네비게이션 링크 화면 표시를 담당하는 Bool 값들을 앱 매니저의 viewStacks에서 관리함
+ isAction이라는 내부 저장 프로퍼티를 이용해 루트뷰로 이동하는 경우, 일반적인 뷰 전환 로직과 충돌을 방지
```swift
final class AppManager:ObservableObject{
	@Published private var viewStacks:[Bool] = []{
        didSet{
            print("\(oldValue) \(viewStacks)")
            guard !isAction else {return}
            if isAction{
                print("Popping Actioned!! \(oldValue) \(viewStacks)")
            }else{
                // O(1)
                guard oldValue.count == viewStacks.count else { return }
                // O(1) -> 중간 back을 누른 뷰가 false로 바뀐다. -> 오류 발생 중단
                // guard oldValue[oldValue.count-2] == viewStacks[viewStacks.count-2] else {return}
                guard oldValue == viewStacks else { return } //O(n)
                _ = self.viewStacks.popLast()
            }
        }
    }
    public private(set) var isAction: Bool = false
    ...
    func goParentView(upToIdx: Int,nextType:MainLinkViewType? = nil){
        self.isAction = true
        let trueLen = viewStacks.count - 2
        guard viewStacks.count - 1 >= upToIdx else {
            print("over Idx!!")
            return
        }
        for i in 0..<upToIdx{
            self.viewStacks[trueLen - i] = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            for _ in 0..<upToIdx{
                if self.viewStacks.count > 1{
                    _ = self.viewStacks.popLast()
                }
            }
            self.isAction = false
            guard let nextType = nextType else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.6){
                self.mainViewLink.send(nextType)
            }
        }
    }
```

### 3. 지도 화면 이동시 실시간 업데이트 정보 제공 기능
> [!IMPORTANT]
> Combine과 MapKit을 활용한 기능
+ 사용자가 지도 위치를 바꾸는 것을 1초마다 Debounce 해서 좌표를 가져옴
+ 가장 최근에 정보를 가져온 위치와 반경 500가 차이나는지 비교 후, 현재 위치 값을 변경
+ 현재 위치가 바뀌면 위치에 대한 주소 값, 주변 병해 정보를 요청하는 통신 수행
~~~swift
self.$region.debounce(for: .seconds(1), scheduler: DispatchQueue.main)
	.sink {[weak self] output in
		guard let _self = self else { return }
		let geo = Geo(output.center.latitude,output.center.longitude)
		_self.service.requestAddress(geo: geo)
			if _self.isDistanceGreaterThanOrEqualTo500m(
			lat1: _self.center.latitude,
			lon1: _self.center.longtitude,
			lat2: geo.latitude,
			lon2: geo.longtitude
			){
				print("좌표 차이가 커 병해 진단!!")
				_self.center = geo
                }else{
                    print("좌표 차이가 작아 병해 진단하지 않음!!")
			}
}.store(in: &subscription)
~~~
