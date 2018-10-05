//
//  CellClasses.swift
//  TaskApp
//
//  Created by Matthew Wells on 10/4/18.
//  Copyright © 2018 Matthew Wells. All rights reserved.
//

import Foundation
import UIKit

class Header: UITableViewHeaderFooterView{
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let floatView: UIView = {
        let fView = UIView()
        fView.layer.cornerRadius = 5
        fView.translatesAutoresizingMaskIntoConstraints = false
        fView.backgroundColor = .clear
        return fView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Tasks"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date Due"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    func setupViews(){
        addSubview(floatView)
        floatView.addSubview(nameLabel)
        floatView.addSubview(dateLabel)
        
        floatView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor,padding: .init(top: 0, left: 15, bottom: 10, right: 15))
        nameLabel.anchor(top: floatView.safeAreaLayoutGuide.topAnchor, leading: floatView.leadingAnchor, bottom: floatView.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 5, left: 15, bottom: 5, right: 5), size: .init(width: 100, height: 20))
        //dateLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 5, right: 0))
        dateLabel.centerXAnchor.constraint(equalTo: floatView.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: floatView.centerYAnchor).isActive = true
    }
}

class MyCell: UITableViewCell {
    
    var myTableViewController: TaskViewController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Label"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let timeLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Sample Text"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return textLabel
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Finished", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let floatView: UIView = {
        let viewFloat = UIView()
        viewFloat.layer.cornerRadius = 5
        viewFloat.layer.borderColor = UIColor.darkGray.cgColor
        viewFloat.layer.borderWidth = 2
        viewFloat.translatesAutoresizingMaskIntoConstraints = false
        return viewFloat
    }()
    
    func setupViews(){
        self.backgroundColor = .clear
        addSubview(floatView)
        floatView.addSubview(nameLabel)
        floatView.addSubview(timeLabel)
        floatView.addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(MyCell.handleAction), for: .touchUpInside)
        
        floatView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor,padding: .init(top: 10, left: 25, bottom: 10, right: 25))
        nameLabel.anchor(top: floatView.topAnchor, leading: floatView.leadingAnchor, bottom: floatView.bottomAnchor, trailing: nil, padding: .init(top: 5, left: 15, bottom: 5, right: 0),size: .init(width: 100, height: 40))
        //timeLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 5, right: 0))
        timeLabel.centerXAnchor.constraint(equalTo: floatView.centerXAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: floatView.centerYAnchor).isActive = true
        actionButton.anchor(top: floatView.topAnchor, leading: nil, bottom: floatView.bottomAnchor, trailing: floatView.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 5, right: 15))
    }
    
    
    @objc func handleAction() {
        myTableViewController?.deleteCell(cell: self)
    }
}


class Footer: UITableViewHeaderFooterView {
    

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Footer PlaceHolder"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setUpViews() {
        self.addSubview(totalLabel)
        
        totalLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        totalLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}







