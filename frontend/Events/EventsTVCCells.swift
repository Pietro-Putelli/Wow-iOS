//
//  EventsTVCCells.swift
//  eventsProject
//
//  Created by Pietro Putelli on 25/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventTitleCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var eventTitleLabel: UILabel!
}

class EventDataPlaceCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var dataTitleLabel: UILabel!
    @IBOutlet weak var dataSubtitleLabel: UILabel!
}

class EventPlaceCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var placeSubtitleLabel: UILabel!
}

class EventLikeGoingShareCell: UITableViewCell {
    @IBOutlet weak var going_background_view: UIView!
    @IBOutlet weak var like_background_view: UIView!
    @IBOutlet weak var goingIcon: UIButton!
    @IBOutlet weak var likeIcon: UIButton!
    @IBOutlet weak var goingTitleLabel: UILabel!
    @IBOutlet weak var likeTitleLabel: UILabel!
    @IBOutlet weak var goingNumberLabel: UILabel!
    @IBOutlet weak var likeNumberLabel: UILabel!
}

class EventDetailsTitleCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var eventDetailsTitleLabel: UILabel!
}

class EventDetailsCell: UITableViewCell {
    @IBOutlet weak var backgorund_view: UIView!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var showButtonOutlet: UIButton!
}

class EventSpecificInfoCell: UITableViewCell {
    @IBOutlet weak var backgorund_view: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLbael: UILabel!
}

class EventContactTitleCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var contactTitleLabel: UILabel!
}

class EventContactCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class EventPositionInfoTitleCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var positionInfoTitleLabel: UILabel!
}

class EventPositionInfoCell: UITableViewCell, MKMapViewDelegate {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var expandMapButtonOutlet: UIButton!
    @IBOutlet weak var directionTitleLabel: UILabel!
    @IBOutlet weak var getDirectionButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        map.delegate = self
        map.layer.cornerRadius = self.frame.width / 32
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

class EventMoreInfoCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class EventDiscussionTitleCell: UITableViewCell {
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var discussionTitleLabel: UILabel!
}

class EventWriteDiscussionCell: UITableViewCell {
    @IBOutlet weak var writeDiscussionTitleLabel: UILabel!
    @IBOutlet weak var background_view: UIView!
}



