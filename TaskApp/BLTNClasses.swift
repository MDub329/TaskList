//
//  BLTNClasses.swift
//  TaskApp
//
//  Created by Matthew Wells on 10/2/18.
//  Copyright © 2018 Matthew Wells. All rights reserved.
//

import Foundation
import BLTNBoard
import UIKit

class TextFieldBLTNPage: BLTNPageItem {
    var textField = UITextField()
    var textField1 = UITextField()
    var textFieldString = "Holder"
    var textFieldString1 = "Holder1"
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        
        textField = interfaceBuilder.makeTextField(placeholder: "Enter Task Name", returnKey: .done, delegate: self as? UITextFieldDelegate)
        textField.text = textFieldString
        
        //textField.textColor = .red
//        textField1 = interfaceBuilder.makeTextField(placeholder: "Enter Due Date", returnKey: .done, delegate: self as? UITextFieldDelegate)
//        textField1.text = textFieldString1
        //textField1.textColor = .blue
        return [textField]
    }
}

class DueDatePicker: BLTNPageItem {
    
    let datePicker = UIDatePicker()
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.setValue(UIColor.white, forKey: "textColor")
        return [datePicker]
    }
    
    
}


