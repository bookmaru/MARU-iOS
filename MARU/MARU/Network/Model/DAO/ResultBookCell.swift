//
//  ResultBookCell.swift
//  
//
//  Created by 이윤진 on 2021/09/22.
//

import UIKit

final class ResultBookCell: UICollectionViewCell {
    private let shadowView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.applyShadow(color: .black, alpha: 0.15, shadowX: 0, shadowY: 2, blur: 5/2)
    }

    private let bookImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }

    private let bookTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.text = "책 제목"
    }

    private let bookAuthorLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        $0.text = "이이이리리리"
    }

    private let addBookButton = UIButton().then {
        $0.setImage(Image.validName, for: .normal)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bookTitleLabel.text = nil
        bookAuthorLabel.text = nil
        bookImageView.image  = nil
    }

    func bind(_ bookModel: BookModel) {
        bookTitleLabel.text = bookModel.title
        bookAuthorLabel.text = bookModel.author
        // TODO: - 책 이미지 없는 경우 처리
        if bookModel.imageUrl != "" {
            bookImageView.imageFromUrl(bookModel.imageUrl, defaultImgPath: "")
        }
        bookImageView.image = Image.group1029
    }
    private func applyLayout() {
        add(shadowView)
        shadowView.adds([
            bookImageView,
            bookTitleLabel,
            bookAuthorLabel,
            addBookButton
        ])

        shadowView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(3)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
            make.leading.equalTo(contentView.snp.leading).offset(3)
            make.trailing.equalTo(contentView.snp.trailing).offset(-3)
        }

        bookImageView.snp.makeConstraints { make in
            make.top.equalTo(shadowView.snp.top).inset(0)
            make.leading.equalTo(shadowView.snp.leading).inset(0)
            make.bottom.equalTo(shadowView.snp.bottom).inset(0)
            make.width.equalTo(96)
        }

        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(shadowView).offset(10)
            make.leading.equalTo(bookImageView.snp.trailing).offset(10)
            make.width.equalTo(190)
            make.height.equalTo(13)
        }

        bookAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(bookTitleLabel.snp.leading)
            make.width.equalTo(190)
            make.height.equalTo(10)
        }

        addBookButton.snp.makeConstraints { make in
            make.trailing.equalTo(shadowView.snp.trailing).offset(-10)
            make.bottom.equalTo(shadowView.snp.bottom).offset(-12)
            make.height.equalTo(22)
        }
    }
    func name() -> String? {
        return bookTitleLabel.text
    }
}
