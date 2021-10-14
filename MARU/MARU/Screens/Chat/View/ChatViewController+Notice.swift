//
//  ChatViewController+Notice.swift
//  MARU
//
//  Created by 오준현 on 2021/10/11.
//

import UIKit

extension ChatViewController {
  func notice(roomID: Int) {
    let noticeView = UIView().then {
        $0.backgroundColor = .white
        $0.alpha = 0.6
    }

    let noticeLabel = UILabel().then {
      $0.text = "토론방의 유지기간은 1주일입니다. 1주일 후 방에 입장하실 수 없습니다. 비속어 및 욕설, 상대방에 대한 인신공격은 금지합니다. 스팸, 광고성 홍보글은 금지합니다. 토론방의 목적에 맞게 토론합니다."
      $0.numberOfLines = 0
      $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
      $0.textAlignment = .justified
    }

    let noticeDeleteButton = UIButton().then {
      $0.setImage(Image.normalX?.withRenderingMode(.alwaysTemplate), for: .normal)
      $0.tintColor = .black
    }

    view.add(noticeView)
    noticeView.add(noticeLabel)
    noticeView.add(noticeDeleteButton)

    noticeView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(68)
    }

    noticeLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-48)
    }

    noticeDeleteButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview()
      make.size.equalTo(40)
    }

    noticeDeleteButton.rx.tap
      .subscribe(onNext: { _ in
        UserDefaults.standard.setValue(true, forKey: "room\(roomID)")
        noticeView.removeFromSuperview()
      })
      .disposed(by: disposeBag)
  }
}
