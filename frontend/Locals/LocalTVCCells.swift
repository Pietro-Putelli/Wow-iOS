//
//  LocalTVCCells.swift
//  eventsProject
//
//  Created by Pietro Putelli on 14/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import MapKit

extension LocalSpecificInfoIconCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoCell", for: indexPath) as! InfoIconCell
        cell.imageView.image = collectionViewIcons[indexPath.row]
        cell.titleLabel.text = collectionViewTitles[indexPath.row]
        cell.backgroundColor = currentTheme.backgroundColor
        cell.titleLabel.textColor = currentTheme.textColor
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 70, height: 90)
        
//        UICollectionViewFlowLayoutAutomaticSize
    }
}

class InfoIconCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class LocalTitleCell: UITableViewCell {
    @IBOutlet weak var localTitleLabel: UILabel!
    @IBOutlet weak var localSubtitleLabel: UILabel!
    @IBOutlet weak var background_view: UIView!
}

class LocalTimeCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var showTimetableButtonOutlet: UIButton!
    @IBOutlet weak var dayTimeTitleLabel: UILabel!
    @IBOutlet weak var openClosedLabel: UILabel!
}

class LocalDaysWeekCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var mondayTitleLabel: UILabel!
    @IBOutlet weak var mondayTimetableLabel: UILabel!
    @IBOutlet weak var thuesdayTitleLabel: UILabel!
    @IBOutlet weak var thuesdayTimetableLabel: UILabel!
    @IBOutlet weak var wednsdayTitleLabel: UILabel!
    @IBOutlet weak var wednesdayTimetableLabel: UILabel!
    @IBOutlet weak var thursdayTitleLabel: UILabel!
    @IBOutlet weak var thursdayTimetableLabel: UILabel!
    @IBOutlet weak var fridayTitleLabel: UILabel!
    @IBOutlet weak var fridayTimetableLabel: UILabel!
    @IBOutlet weak var saturdayTitleLabel: UILabel!
    @IBOutlet weak var saturdayTimetableLabel: UILabel!
    @IBOutlet weak var sundayTitleLabel: UILabel!
    @IBOutlet weak var sundayTimetableLabel: UILabel!
}

class LocalPositionCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var markerIcon: UIImageView!
    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
}

class LocalRatingViewCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var localRateBar: RatingView!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        localRateBar.backgroundColor = UIColor.clear
        localRateBar.contentMode = .scaleAspectFit
    }
}

class LocalLikeFavShareCell: UITableViewCell {
    @IBOutlet weak var background_view_1: UIView!
    @IBOutlet weak var background_view_2: UIView!
    @IBOutlet weak var likeIcon: UIButton!
    @IBOutlet weak var numberOfLikeLabel: UILabel!
    @IBOutlet weak var moreIcon: UIButton!
}

class LocalDetailsTitleCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var detailsTitleLabel: UILabel!
}

class LocalDetailsCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var localDetailsContentLabel: UILabel!
    @IBOutlet weak var showMoreButtonOutlet: UIButton!
}

class LocalSpecificInfoCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class LocalEventCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var background_view: UIView!
}

class LocalSpecificInfoIconCell: UITableViewCell {
    
    var collectionViewIcons = [UIImage]()
    var collectionViewTitles = [String]()
    
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.layer.cornerRadius = self.background_view.frame.width / 32
        collectionView.backgroundColor = currentTheme.backgroundColor
    }
}

class LocalContactTitleCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var contactTitleLabel: UILabel!
}

class LocalContactCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var background_view: UIView!
}

class LocalPositionInfoTitleCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var positionInfoTitleLabel: UILabel!
}

class LocalPositionInfoCell: UITableViewCell, MKMapViewDelegate {
    
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var expandMapButtonOutlet: UIButton!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var getDirectionButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        map.delegate = self
        map.layer.cornerRadius = self.background_view.frame.width / 32
        map.clipsToBounds = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationReuseId = "Place"
        var anView = map.dequeueReusableAnnotationView(withIdentifier: annotationReuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        } else {
            anView?.annotation = annotation
        }
        anView!.image = UIImage(named: "mapMarker")
        anView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        anView!.backgroundColor = .clear
        anView!.canShowCallout = false
        return anView
    }
}

class LocalMoreInfoCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class LocalReviewTitleCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var reviewTitleLabel: UILabel!
}

class LocalReviewCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var rateBarView: RatingView!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
}

class LocalWriteReviewCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var writeReviewTitleLabel: UILabel!
}

class LocalUserReviewCell: UITableViewCell {
    
    var isContntExpanded: Bool!
    var dropMenu: UIAlertController!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var userReviewMenu: UIButton!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var showMoreButton: UIButton!
}
