//
//  LocalPhotosCVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 10/08/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import OpalImagePicker

class UILocalImage: UIImage {
    var id = String()
}

protocol PhotoCellDelegate: class {
    func delete(cell: PhotoCell)
}

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    
    weak var delegate: PhotoCellDelegate?
    
    var isEditing: Bool = false {
        didSet {
            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        self.delegate?.delete(cell: self)
    }
}

struct Storyboard {
    
    static let photoCell = "photoCell"
    static let leftAmdRightPadding: CGFloat = 2.0
    static let numberOfItemsPerRow: CGFloat = 3.0
    static let showDetailVC = "showImageDetail"
}

extension LocalPhotosCVC: PhotoCellDelegate {
    
    func delete(cell: PhotoCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
            imagesArray.remove(at: indexPath.item)
            collectionView?.deleteItems(at: [indexPath])
            Database.deleteImgae(id: selectedLocal.id!, index: indexPath.item, email: User.email)
            print("\(selectedLocal.id!) \(indexPath.item) \(User.email)")
        }
    }
}

extension LocalPhotosCVC: OpalImagePickerControllerDelegate {
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        self.dismiss(animated: true, completion: {
            UIApplication.shared.statusBarStyle = .lightContent
            
            self.imagesPicked.append(contentsOf: images)
            self.collectionView?.reloadData()
        })
    }
}

class LocalPhotosCVC: UICollectionViewController {

    @IBOutlet weak var addNewItem: UIBarButtonItem!
    
    static var images = [UIImage]()
    static var nuberOfImages = Int()
    
    var selectedLocal: Local!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    var imagePickerController = OpalImagePickerController()
    
    var imagesArray = [UIImage]()
    var imagesPicked = [UIImage]()
    var imagesID = [String]()
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewWidth = collectionView?.frame.width
        let itemWidth = (collectionViewWidth! - Storyboard.leftAmdRightPadding) / Storyboard.numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collectionView?.contentInset = UIEdgeInsetsMake(2, 0, 0, 0)
        
        editButtonItem.tintColor = addNewItem.tintColor
        navigationItem.rightBarButtonItems = [addNewItem,editButtonItem]
        view.layer.cornerRadius = view.frame.width / 64
        
        LocalPhotosCVC.nuberOfImages = 0

        if let selectedLocal = selectedLocal {
            Database.getImagesID(id: selectedLocal.id!) { (ids) in
                self.imagesID = ids
                self.downloadImages(imageIDs: ids)
            }
        }
    }
    
    func downloadImages(imageIDs:[String]) {
        for i in 0..<imageIDs.count {
            let downloadURL = URL(string: "https://finixinc.com/usersAccountData/\(User.email)/userLocals/\(User.email)\(selectedLocal.id!)/\(imageIDs[i]).jpg")
            Database.downloadImage(withURL: downloadURL!) { (downloadedImg) in
                if let image = downloadedImg {
                    self.imagesArray.append(image)
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    @objc func presentAlbum() {
        imagePickerController.imagePickerDelegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        self.presentAlbum()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imagesPicked + imagesArray).count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.photoCell, for: indexPath) as! PhotoCell
        let allPhotos = imagesArray + imagesPicked
        cell.photoImageView.image = allPhotos[indexPath.item]
        cell.deleteButtonBackgroundView.layer.cornerRadius = cell.deleteButtonBackgroundView.bounds.width / 2
        cell.deleteButtonBackgroundView.layer.masksToBounds = true
        cell.deleteButtonBackgroundView.isHidden = !cell.isEditing
        cell.delegate = self
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addNewItem.isEnabled = !editing
        
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? PhotoCell {
                    cell.isEditing = editing
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let allPhotos = imagesArray + imagesPicked
        selectedImage = allPhotos[indexPath.item]
        self.performSegue(withIdentifier: Storyboard.showDetailVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showDetailVC {
            let detailVC = segue.destination as! PhotoDetailVC
            detailVC.image = selectedImage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        collectionView?.backgroundColor = currentTheme.backgroundColor
        navigationItem.title = User.language.photos_album
        
        imagePickerController.navigationBar.barStyle = .black
        imagePickerController.navigationBar.barTintColor = currentTheme.barColor
        imagePickerController.navigationItem.rightBarButtonItem?.tintColor = currentTheme.textColor
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backArrow").withRenderingMode(.automatic)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LocalPhotosCVC.images = imagesPicked
        print(LocalPhotosCVC.nuberOfImages)
    }
}
