//
//  MorePopularViewController.swift
//  MARU
//
//  Created by psychehose on 2021/05/29.
//

import UIKit

class MorePopularViewController: BaseViewController, UICollectionViewDelegate {

  enum Section {
      case main
  }

  let titleLabel = UILabel().then {
    $0.adjustsFontSizeToFitWidth = true
    $0.sizeToFit()
    $0.textAlignment = .left
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = .black
    $0.text = "지금 새로나온 모임"
  }

  var allButton: UIButton = UIButton()
  var artButton: UIButton = UIButton()
  var literalButton: UIButton = UIButton()
  var scienceButton: UIButton = UIButton()
  var philisophyButton: UIButton = UIButton()

  private lazy var dataSource = configureDataSource()
  private var collectionView: UICollectionView! = nil

  private let screenSize = UIScreen.main.bounds.size
  
  var all : [ViewMainModel] = [
    ViewMainModel.init(book: Book.init(bookImage: "", bookTitle: "A", bookAuthor: "A", bookComment: "A", roomChief: "A", category: "A1")),
    ViewMainModel.init(book: Book.init(bookImage: "", bookTitle: "B", bookAuthor: "B", bookComment: "B", roomChief: "B", category: "B2")),
    ViewMainModel.init(book: Book.init(bookImage: "", bookTitle: "C", bookAuthor: "C", bookComment: "C", roomChief: "C", category: "C3"))]
  var categoryFilter: String?
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section,ViewMainModel>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ViewMainModel>

  override func viewDidLoad() {
    super.viewDidLoad()
    setupButton(title: [
      "전체",
      "예술",
      "문학",
      "자연과학",
      "철학"
    ])
    applyLayout()
    applySnapshot(animatingDifferences: false)
//    configureDataSource()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    setNavigationBar(isHidden: false)
  }
}

extension MorePopularViewController {
    /// - Tag: create CollectionView Layout
  private func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { [self] (_, _) in
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil,
                                                         top: nil,
                                                         trailing: nil,
                                                         bottom: nil)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenSize.width * 0.915),
                                               heightDimension: .absolute(142))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(23))

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section

    }

    return layout
  }
}

extension MorePopularViewController {
    private func applyLayout() {
      collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
      collectionView.backgroundColor = .white
      collectionView.delegate = self
      collectionView.register(cell: NewMeetingCell.self)
      
      view.adds([
        titleLabel,
        allButton,
        artButton,
        literalButton,
        scienceButton,
        philisophyButton,
        collectionView
      ])
      
      titleLabel.snp.makeConstraints { (make) in
        make.top.equalTo(view.safeAreaLayoutGuide).inset(0)
        make.leading.equalToSuperview().inset(20)
        make.height.equalTo(20)
      }

      allButton.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).inset(-8)
        make.leading.equalToSuperview().inset(20)
      }

      artButton.snp.makeConstraints { (make) in
        make.centerY.equalTo(allButton.snp.centerY)
        make.leading.equalTo(allButton.snp.trailing).inset(-5)
      }

      literalButton.snp.makeConstraints { (make) in
        make.centerY.equalTo(allButton.snp.centerY)
        make.leading.equalTo(artButton.snp.trailing).inset(-5)
      }

      scienceButton.snp.makeConstraints { (make) in
        make.centerY.equalTo(allButton.snp.centerY)
        make.leading.equalTo(literalButton.snp.trailing).inset(-5)
      }
      
      philisophyButton.snp.makeConstraints { (make) in
        make.centerY.equalTo(allButton.snp.centerY)
        make.leading.equalTo(scienceButton.snp.trailing).inset(-5)
      }
      
      collectionView.snp.makeConstraints { (make) in
        make.top.equalTo(allButton.snp.bottom).inset(-14)
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      }
    }

  private func setupButton(title: [String]) {
    [allButton,
     artButton,
     literalButton,
     scienceButton,
     philisophyButton].enumerated().forEach { index, button in
      button.backgroundColor = .white
      button.layer.borderWidth = 1
      button.layer.borderColor = UIColor.veryLightPinkFour.cgColor
      button.layer.cornerRadius = 14
      button.sizeToFit()
      button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
      button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
      button.setTitleColor(.brownGreyThree, for: .normal)
      button.titleLabel?.textAlignment = .center
      button.setTitle(title[index], for: .normal)
     }
  }
  
  private func configureDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView, cellProvider: { (collectionView, indexPath, viewMainModel) -> UICollectionViewCell? in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMeetingCell.reuseIdentifier, for: indexPath) as? NewMeetingCell
        cell?.viewMainModel = viewMainModel
        return cell
      })
    return dataSource
  }
  func applySnapshot(animatingDifferences: Bool = true) {
    // 2
    var snapshot = Snapshot()
    // 3
    snapshot.appendSections([.main])
    // 4
//    sections.forEach { section in
//      snapshot.appendItems(section.videos, toSection: section)
//    }
    // 5
    snapshot.appendItems(all)
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}

extension MorePopularViewController {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let viewMainModel = dataSource.itemIdentifier(for: indexPath) else {
      return
    }
  }
}

