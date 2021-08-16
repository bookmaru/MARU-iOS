//
//  CreateQuiz1Cell.swift
//  MARU
//
//  Created by 이윤진 on 2021/08/16.
//

import UIKit

class CreateQuiz1Cell: UITableViewCell {

  private let titleLabel = UILabel().then {
    $0.text = "Quiz1"
  }
  private let quizTextView = UITextView().then {
    $0.layer.cornerRadius = 8.0
  }
  private let correctButton = UIButton().then {
    $0.setImage(UIImage(systemName: "correctWhite"), for: .normal)
  }
  private let incorrectButton = UIButton().then {
    $0.setImage(UIImage(systemName: "incorrectRed"), for: .normal)
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
