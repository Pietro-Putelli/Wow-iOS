//
//  MySharedVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 01/09/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class MySharedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: CustomSegmenteControl!
    
    @IBOutlet var noSharedView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var shared = [Int]()
    var received = [Int]()
    
    var isReceivedSelected = Bool()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        segmentedControl.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    func addNoSharedView() {
        view.addSubview(noSharedView)
        
        noSharedView.frame.size.width = view.frame.size.width - 40
        noSharedView.center = view.center
        noSharedView.backgroundColor = currentTheme.backgroundColor
        label1.textColor = currentTheme.textColor
        descriptionLabel.textColor = currentTheme.textColor
    }
    
    @objc func valueChanged(_ sender: AnyObject?) {
        if isReceivedSelected {
            descriptionLabel.text = "Locals and events shared with your friends will appear here."
            isReceivedSelected = !isReceivedSelected
        } else {
            descriptionLabel.text = "Locals and events that your friends shared with you will appear here."
            isReceivedSelected = !isReceivedSelected
        }
        
        tableView.reloadData()
        
        if isReceivedSelected && received.isEmpty { self.addNoSharedView() }
        else if !isReceivedSelected && shared.isEmpty { self.addNoSharedView() }
        else { noSharedView.removeFromSuperview() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        
        segmentedControl.items = ["Shared","Received"]
        segmentedControl.font = UIFont(name: "Accuratist", size: 16)
        segmentedControl.tintColor = currentTheme.separatorColor
        segmentedControl.borderColor = currentTheme.separatorColor
        segmentedControl.selectedLabelColor = currentTheme.backgroundColor
        segmentedControl.thumbColor = currentTheme.separatorColor
        segmentedControl.unselectedLabelColor = currentTheme.textColor
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundColor
        tableView.separatorColor = currentTheme.separatorColor
        
        if isReceivedSelected && received.isEmpty { self.addNoSharedView() }
        else if !isReceivedSelected && shared.isEmpty { self.addNoSharedView() }
        else { noSharedView.removeFromSuperview() }
    }
}

extension MySharedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isReceivedSelected { return received.count }
        else { return shared.count }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}






