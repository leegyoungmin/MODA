# MODA
아침마다 작성하는 일기 작성을 도와주는 앱이다. 성공하는 사람들의 습관인 아침에 일기 쓰는 것을 도와준다.

![Frame 1](https://github.com/leegyoungmin/MODA/assets/52390923/0fb10032-7f7f-447b-abd7-7f67d81e0cc8)

## 🛠️ 사용 기술 및 라이브러리

- Swift, iOS
- SnapKit
- RxSwift
- MVVM

## 📱 구현한 기능 (iOS)

- **SnapKit** 을 활용하여 코드로 오토 레이아웃 구현
- 작성 된 일기를 보여주는 리스트 구현
- 사용자 알림 구현 - 설정한 시간에 알림을 보내는 기능
- 커스텀 뷰 구현 - 사용자 인증 폼 뷰, 하단 모달 뷰, 캘린더 뷰

## 고민한 점

### 1. Layer의 구분
- 고민한 점 & 해결법

  활용하는 플랫폼의 수는 적지만, 다양한 타입에 대해서 상호작용을 하는 부분이 많이 존재하게 되었습니다. Layer를 구분하는 방법에 대해서 고민하게 되었습니다. 고민하던 중 `Clean Architecture` 라는 아키텍쳐에 대해서 알게 되었습니다. 

  ![Clean Architecture](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/raw/master/README_FILES/CleanArchitecture+MVVM.png?raw=true)

  `Clean Architecture` 는 위의 그림과 같이 레이어를 구분하고, 객체의 방향을 단 방향으로 설정하는 패턴이다.

  해당 프로젝트에서는 일기에 대한 데이터와 사용자에 대한 데이터를 따로 관리하는 목적으로 활용하게 되었다. 실질적으로 해당 패턴을 활용하면, 여러가지의 데이터 베이스를 활용하거나 다양한 API를 활용할 때 이들을 구분하는 이점을 얻을 수 있다. 

- 프로젝트 적용

  ![Morning Diary](https://github.com/leegyoungmin/MODA/assets/52390923/26d162aa-375f-4de5-8141-1bc590afa3ef)

  - 사용자에게 화면을 보여주는 부분이 `ViewModel` 은 `UseCase` 를 통해서 데이터를 생성하고, 사용자에게 보여주는 역할
  - `UseCase` 는 다양한 `Repository` 타입을 통해서 데이터를 생산하고, 가공하는 역할
  - `Repository` 는 실질적으로 `Service` 와 소통하여서 `UseCase` 에서 필요한 데이터를 생성하는 역할
  - 각각의 `Service` 는 한개의 API를 활용하기 때문에 하나의 객체로 구현할 수 있지만, 프로젝트에서는 이들을 구분하기 위한 목적으로 두개의 타입으로 구현하게 되었다.

### 2. 하단 Sheet의 ChildViewController
  |예시 1|예시 2|
  |---|---|
  |![IMG_C4ECE0FADF08-1](https://github.com/leegyoungmin/MODA/assets/52390923/17f8b1a3-8851-48eb-8c02-ec109237da5a)|![IMG_9C157B962FF1-1](https://github.com/leegyoungmin/MODA/assets/52390923/063ed600-06cf-49df-afc5-034d0756273d)|

- 고민 & 해결법

  다음과 같이 하단에서만 표현되는 `Controller` 를 구현하는 것에 대해서 고민하게 되었다. 이를 구현하기 위해서 자료를 찾아보았지만, `View` 를 통해서 구현하는 방법에 대해서 많이 소개 되었다. 

  `View` 를 통해서 구현할 경우, 내부에 구현되어 있는 `View` 들의 데이터를 전달하기 위해서 `Delegate` 를 활용하여 불필요한 단계를 거치게 될 것이다. 즉, 데이터가 필요한 영역에 직접적으로 데이터를 전달할 수 없게 될 것이다. 또한, `BottomSheetController` 를 재사용하기 위해서는 상속을 활용하여야 한다는 단점이 있다. 그래서 다른 방법에 대해서 고민하게 되었다.

  다양한 방법을 고민하던 중, `ViewController` 가 `Child View Controller` 를 소유할 수 있다는 것을 알게 되었다. `Parent` 와 `Child` 는 부모와 자식같은 관계를 형성하게 되고, 하나의 Controller만 추가할 수 있는 것이 아니라 다양한 Controller를 자식으로 추가하고, 이를 전환할 수도 있다. 이와 같은 구조를 활용하는 타입들에는 `UITabViewController` `UINavigationController` 등이 이미 존재하고 있다.

- 프로젝트 적용

  ```swift
  final class BottomSheetViewController: UIViewController {
      private let controller: UIViewController
      
      init(controller: UIViewController) {
          self.controller = controller
          super.init(nibName: nil, bundle: nil)
      }
      
      required init?(coder: NSCoder) {
          self.controller = UIViewController()
          super.init(coder: coder)
      }
  		...
  }
  
  private extension BottomSheetViewController {
  		...
      func configureHierarchy() {
          addChild(controller)
          view.addSubview(controller.view)
          controller.didMove(toParent: self)
      }
      ...
  }
  ```

  위와 같이 `BottomSheetViewController` 를 구현하게 되었으며, 생성자를 통해서 하나의 자식 `ViewController` 를 주입 할 수 있습니다. 이를 통해서 뷰를 구성하는 단계에서 자식 `Controller` 로 설정하게 되고, `Parent View` 에 `Child View Controller` 의 뷰를 추가하였습니다.

  이를 통해서 자식 `ViewController` 가 직접적으로 데이터가 필요한 `ViewController` 와 상호작용할 수 있게 되었다. 또한, 내부에 필요한 뷰의 변화에 `ViewController` 의 재사용을 통해서 상속을 구현하지 않고 활용할 수 있게 됩니다.
