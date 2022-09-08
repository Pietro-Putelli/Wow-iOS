//
//  LocalQuickInfoCVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 26/11/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var check: UIImageView!
}

class LocalQuickInfoVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var titles = [String]()
    var icons = [UIImage]()
    var itemsSelected = [Int]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
        
        icons = [#imageLiteral(resourceName: "parking1"),#imageLiteral(resourceName: "wifi"),#imageLiteral(resourceName: "music2"),#imageLiteral(resourceName: "tv"),#imageLiteral(resourceName: "place1"),#imageLiteral(resourceName: "sport1"),#imageLiteral(resourceName: "games1"),#imageLiteral(resourceName: "slot"),#imageLiteral(resourceName: "kids1"),#imageLiteral(resourceName: "cocktail1"),#imageLiteral(resourceName: "food1"),#imageLiteral(resourceName: "cake2"),#imageLiteral(resourceName: "pizza1"),#imageLiteral(resourceName: "wine1"),#imageLiteral(resourceName: "dog")]
        titles = ["Parking","Free wifi","Music","TV","Outside sitting","Sport","Games","Slot","Good for kids","Cocktails","Food","Birthday","Take away food","Food and wine","Pets"]
        
        self.setCollectionViewFlowLayout()
    }
    
    func setCollectionViewFlowLayout() {

        let numberOfCellsPerRow: CGFloat = 3
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            
            let insetX: CGFloat = 3
            let insetY = insetX / 2
            
            let cellWidth = (CGFloat(view.frame.width - insetX * 4) - CGFloat(max(1, numberOfCellsPerRow - 1)) * horizontalSpacing) / numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: 1.2 * cellWidth)
            
            collectionView.contentInset = UIEdgeInsetsMake(insetY, insetX, insetY, insetX)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        collectionView.backgroundColor = currentTheme.backgroundSeparatorColor
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(itemsSelected, forKey: "QUICK_INFO")
    }
}

extension LocalQuickInfoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? IconCell {
            if cell.check.isHidden {
                cell.check.isHidden = !cell.check.isHidden
                itemsSelected.append(indexPath.item)
            } else {
                cell.check.isHidden = !cell.check.isHidden
                itemsSelected = itemsSelected.filter { $0 != indexPath.item }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IconCell
        
        cell.backgroundColor = currentTheme.backgroundColor
        cell.titleLabel.textColor = currentTheme.textColor
        
        cell.iconView.image = icons[indexPath.item]
        cell.titleLabel.text = titles[indexPath.item]
        
        cell.check.tintColor = currentTheme.textColor
        cell.check.image?.withRenderingMode(.alwaysTemplate)
        
        if itemsSelected.contains(indexPath.item) {
            cell.check.isHidden = false
        } else {
            cell.check.isHidden = true
        }
        
        cell.layer.cornerRadius = cell.frame.width / 32
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 5, height: 10)
        cell.clipsToBounds = true
        
        return cell
    }
}
