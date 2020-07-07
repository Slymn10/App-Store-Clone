//
//  AppsViewController.swift
//  AppStore
//
//  Created by Süleyman Koçak on 4.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import UIKit

class AppsViewController: UIViewController {
   let sections = Bundle.main.decode([Section].self, from: "appstore.json")
   var collectionView: UICollectionView!

   var dataSource: UICollectionViewDiffableDataSource<Section, App>?

   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Apps"
      navigationController?.navigationBar.prefersLargeTitles = true
      collectionView = UICollectionView(
         frame: view.bounds,
         collectionViewLayout: createCompositionalLayout()
      )
      collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      collectionView.delegate = self
      collectionView.backgroundColor = .systemBackground
      view.addSubview(collectionView)
      collectionView.register(
         SectionHeader.self,
         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
         withReuseIdentifier: SectionHeader.reuseIdentifier
      )
      collectionView.register(
         SmallTableCell.self,
         forCellWithReuseIdentifier: SmallTableCell.reuseIdentifier
      )
      collectionView.register(
         FeaturedCell.self,
         forCellWithReuseIdentifier: FeaturedCell.reuseIdentifier
      )
      collectionView.register(
         MediumTableCell.self,
         forCellWithReuseIdentifier: MediumTableCell.reuseIdentifier
      )
      createDataSource()
      reloadData()
   }

   func configure<T: SelfConfiguringCell>(
      _ cellType: T.Type,
      with app: App,
      for indexPath: IndexPath
   ) -> T {
      guard
         let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
         ) as? T
      else {
         fatalError("Unable to dequeue \(cellType)")
      }
      cell.configure(with: app)
      return cell
   }
   func createDataSource() {
      dataSource = UICollectionViewDiffableDataSource<Section, App>(collectionView: collectionView)
      { collectionView, indexPath, app in
         switch self.sections[indexPath.section].type {
         case "mediumTable":
            return self.configure(MediumTableCell.self, with: app, for: indexPath)
         case "smallTable":
            return self.configure(SmallTableCell.self, with: app, for: indexPath)
         default:
            return self.configure(FeaturedCell.self, with: app, for: indexPath)
         }
      }
      dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
         guard
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(
               ofKind: kind,
               withReuseIdentifier: SectionHeader.reuseIdentifier,
               for: indexPath
            ) as? SectionHeader
         else { return nil }
         guard let firstApp = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
         guard
            let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstApp)
         else { return nil }
         if section.title.isEmpty { return nil }
         sectionHeader.title.text = section.title
         sectionHeader.subtitle.text = section.subtitle
         return sectionHeader
      }
   }
   func createCompositionalLayout() -> UICollectionViewLayout {
      let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
         let section = self.sections[sectionIndex]

         switch section.type {
         case "mediumTable":
            return self.createMediumTableSection(using: section)
         case "smallTable":
            return self.createSmallTableSection(using: section)
         default:
            return self.createFeaturedSection(using: section)

         }
      }
      let config = UICollectionViewCompositionalLayoutConfiguration()
      config.interSectionSpacing = 20
      layout.configuration = config
      return layout
   }

   func reloadData() {
      var snapshot = NSDiffableDataSourceSnapshot<Section, App>()
      snapshot.appendSections(sections)

      for section in sections {
         snapshot.appendItems(section.items, toSection: section)
      }

      dataSource?.apply(snapshot)
   }



   func createFeaturedSection(using section: Section) -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(1),
         heightDimension: .fractionalHeight(1)
      )
      let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
      layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
      let layoutGroupSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(0.93),
         heightDimension: .estimated(350)
      )
      let layoutGroup = NSCollectionLayoutGroup.horizontal(
         layoutSize: layoutGroupSize,
         subitems: [layoutItem]
      )
      let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
      layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
      return layoutSection
   }
   func createMediumTableSection(using section: Section) -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(1),
         heightDimension: .fractionalHeight(0.33)
      )
      let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
      layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
      let layoutGroupSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(0.97),
         heightDimension: .fractionalWidth(0.55)
      )
      let layoutGroup = NSCollectionLayoutGroup.vertical(
         layoutSize: layoutGroupSize,
         subitems: [layoutItem]
      )
      let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
      layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
      let layoutSectionHeader = createSectionHeader()
      layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
      return layoutSection
   }
   func createSmallTableSection(using section: Section) -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(1),
         heightDimension: .fractionalHeight(0.2)
      )
      let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
      layoutItem.contentInsets = NSDirectionalEdgeInsets(
         top: 0,
         leading: 20,
         bottom: 0,
         trailing: 0
      )
      let groupSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(0.96),
         heightDimension: .estimated(200)
      )
      let layoutGroup = NSCollectionLayoutGroup.vertical(
         layoutSize: groupSize,
         subitems: [layoutItem]
      )
      let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
      let layoutSectionHeader = createSectionHeader()
      layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
      return layoutSection
   }
   func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
      let layoutSectionHeaderSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(0.95),
         heightDimension: .estimated(80)
      )
      let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
         layoutSize: layoutSectionHeaderSize,
         elementKind: UICollectionView.elementKindSectionHeader,
         alignment: .top
      )
      return layoutSectionHeader
   }
}

extension AppsViewController: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let item = dataSource?.itemIdentifier(for: indexPath)?.name
      print(item!)
   }
    
}
