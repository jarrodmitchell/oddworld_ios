//
//  FormValidationUtility.swift
//  High Strangeness
//
//  Created by penguindrum on 9/6/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import Foundation
import UIKit

public class FormValidationUtility {
    
    public static func validateEmail(email: String, labelErrorMessage: UILabel?) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces).lowercased()
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        if trimmedEmail.isEmpty {
            if labelErrorMessage != nil {
                labelErrorMessage!.text = "Email cannot be empty"
            }
            return false;
        }else if !emailPredicate.evaluate(with: trimmedEmail) {
            if labelErrorMessage != nil {
                labelErrorMessage!.text = "Invalid Email"
            }
            return false;
        }else{
            if labelErrorMessage != nil {
                labelErrorMessage!.text = ""
            }
        }
        return true;
    }
    
    public static func validatePassword(password: String, labelErrorMessage: UILabel?) -> Bool {
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces);
        
        if trimmedPassword.isEmpty {
            if labelErrorMessage != nil {
                labelErrorMessage!.text = "Password cannot be empty"
            }
            return false;
        }else{
            if labelErrorMessage != nil {
                labelErrorMessage!.text = ""
            }
        }
        return true;
    }
    
    public static func validatePasswordCreation(password: String, labelErrorMessage: UILabel?) -> Bool {
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces);
        
        if trimmedPassword.isEmpty {
            if labelErrorMessage != nil {
                labelErrorMessage!.text = "Password cannot be empty"
            }
            return false;
        }else if trimmedPassword.count < 6 {
            if labelErrorMessage != nil {
                labelErrorMessage!.text = "Password must contain at least 6 characters"
            }
            return false;
        }else{
            if labelErrorMessage != nil {
                labelErrorMessage!.text = ""
            }
        }
        return true;
    }
    
    public static func validateUsername(username: String, labelErrorMessage: UILabel?) -> Bool {
        let trimmedUsername = username.trimmingCharacters(in: .whitespaces);
        
        if trimmedUsername.isEmpty {
            if labelErrorMessage != nil {
                labelErrorMessage!.text = "Username cannot be empty"
            }
            return false;
        }else if trimmedUsername.count > 16 {
            if labelErrorMessage != nil {
                labelErrorMessage!.text = "Username cannot exceed 15 characters"
            }
            return false;
        }else{
            if labelErrorMessage  != nil {
                labelErrorMessage!.text = ""
            }
        }
        return true;
    }
    
    public static func validateTitle(title: String, labelErrorMessage: UILabel) -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces);
        
        if trimmedTitle.isEmpty {
            labelErrorMessage.text = "Title cannot be empty"
            return false;
        }else if trimmedTitle.count > 16 {
            labelErrorMessage.text = "Title cannot exceed 150 characters"
            return false;
        }else{
            labelErrorMessage.text = ""
        }
        return true;
    }
    
    public static func validateDescription(description: String, labelErrorMessage: UILabel) -> Bool {
        let trimmedDescription = description.trimmingCharacters(in: .whitespaces);
        
        if trimmedDescription.isEmpty {
            labelErrorMessage.text = "Description cannot be empty"
            return false;
        }else{
            labelErrorMessage.text = ""
        }
        return true;
    }
    
    public static func validateDate(date: String, labelErrorMessage: UILabel) -> Bool {
        if date == "MM/dd/yyyy" {
            labelErrorMessage.text = "A date must be selected"
            return false;
        }else{
            labelErrorMessage.text = ""
        }
        return true;
    }
    
    public static func validateLocation(location: String, labelErrorMessage: UILabel) -> Bool {
        if location == "Address" {
            labelErrorMessage.text = "A Location must be selected"
            return false;
        }else{
            labelErrorMessage.text = ""
        }
        return true;
    }
}
