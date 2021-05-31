//
//  MeetEntryViewModel.swift
//  MARU
//
//  ** 모임 입장 화면 **
//  Created by 이윤진 on 2021/05/03.
//

import ReactorKit
import RxCocoa
import RxSwift

final class MeetEntryViewModel: ViewModelType {

  
  struct Input {
    // 입장 버튼 눌렀을 때
    let entryButton: Observable<Bool>
  }
  
  struct Output {
    // 모임 입장할 때 넘겨줄 정보가 들어갈 자리일거같음
    // MeetEntryModel모델 다시 구성할 예정
    let information: Driver<MeetEntryModel>
  }

  func transform(input: Input) -> Output {
    let entry = Observable.merge(input.entryButton).map {
      
    }
  }

}
