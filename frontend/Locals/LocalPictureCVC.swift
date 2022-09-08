//
//  LocalPictureCollectionVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 09/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LocalPictureCell: UICollectionViewCell {
    @IBOutlet weak var localPicture: UIImageView!
}

class LocalPictureCVC: UICollectionViewController {

    @IBOutlet weak var localPictureNavBarTitle: UINavigationItem!
    
    var backgroundLoadView = UIView()
    var loadingView: HomeLoadingView!
    var activityIndicator: NVActivityIndicatorView! = nil
    
    var localPictures = [UIImage]()

    var selectedLocal: Local!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.getImagesID(id: selectedLocal.id!) { (ids) in
            DispatchQueue.main.async {
                if !ids.isEmpty {
                    self.downloadImages(imageIDs: ids)
                }
            }
        }
        
        self.presentLoadView()
        self.setCollectionViewFlowLayout()
    }
    
    func setCollectionViewFlowLayout() {
        let cellScaling: CGFloat = 0.98
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2
        let insetY = insetX / 2
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize.width = cellWidth
        collectionView!.contentInset = UIEdgeInsetsMake(insetY, insetX, insetY, insetX)
    }
    
    func presentLoadView() {
        if !backgroundLoadView.isDescendant(of: view) {
            loadingView = LoadingView.homeLoadingView(for: view)
            backgroundLoadView = loadingView.backgroundView
            activityIndicator = loadingView.activityIndicator
            view.addSubview(backgroundLoadView)
            view.addSubview(activityIndicator)
            view.isUserInteractionEnabled = false
        }
    }
    
    func removeLoadView() {
        if backgroundLoadView.isDescendant(of: view) {
            backgroundLoadView.removeFromSuperview()
            activityIndicator.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
    
    func downloadImages(imageIDs:[String]) {
        for i in 0..<imageIDs.count {
            let url = URL(string: "https://finixinc.com/usersAccountData/\(selectedLocal.owner)/userLocals/\(selectedLocal.owner)\(selectedLocal.id!)/\(imageIDs[i]).jpg")
            Database.downloadImage(withURL: url!) { (image) in
                DispatchQueue.main.async {
                    if let image = image {
                        self.localPictures.append(image)
                        self.collectionView?.reloadData()
                        self.removeLoadView()
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return localPictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! LocalPictureCell
        if !localPictures.isEmpty {
            cell.localPicture.image = localPictures[indexPath.row]
        }
        
        cell.localPicture.frame.size.width = view.frame.width
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        collectionView?.backgroundColor = currentTheme.backgroundSeparatorColor
        navigationItem.title = User.language.photos_album
    }
}
