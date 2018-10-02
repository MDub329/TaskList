//
//  BLTNClasses.swift
//  TaskApp
//
//  Created by Matthew Wells on 10/2/18.
//  Copyright © 2018 Matthew Wells. All rights reserved.
//

import Foundation
import BLTNBoard

class TextFieldBLTNPage: BLTNPageItem {
    var textField = UITextField()
    var textField1 = UITextField()
    
    //    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
    //        textField = interfaceBuilder.makeTextField(placeholder: "TEST PLACE HOLDER", returnKey: .done, delegate: self as? UITextFieldDelegate)
    //        textField.textColor = .blue
    //        //change textField here
    //        return [textField]
    //    }
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        
        textField = interfaceBuilder.makeTextField(placeholder: "Enter Task Name", returnKey: .done, delegate: self as? UITextFieldDelegate)
        textField.textColor = .red
        textField1 = interfaceBuilder.makeTextField(placeholder: "Enter Due Date", returnKey: .done, delegate: self as? UITextFieldDelegate)
        textField1.textColor = .blue
        return [textField, textField1]
    }
    
    
    
}