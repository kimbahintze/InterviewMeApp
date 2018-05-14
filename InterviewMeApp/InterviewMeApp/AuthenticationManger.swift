//
//  AuthenticationManger.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/14/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
//import FirebaseAuth

class FirebaseAuthenticationManager {
    
//    //MARK: - Properties
//    
//    var user: User? {
//        return Auth.auth().currentUser
//    }
//    
//    static let shared = FirebaseAuthenticationManager()
//    
//    //MARK: - Error Handling
//    enum ErrorStatus {
//        
//        enum LoginError: String {
//            case userDisabled = "ERROR_USER_DISABLED"
//            case invalidEmail = "ERROR_INVALID_EMAIL"
//            case userNotFound = "ERROR_USER_NOT_FOUND"
//            case wrongPassword = "ERROR_WRONG_PASSWORD"
//        }
//        
//        enum SignupError: String {
//            case invalidEmail = "ERROR_INVALID_EMAIL"
//            case emailAlreadyInUse = "ERROR_EMAIL_ALREADY_IN_USE"
//            case weakPassword = "ERROR_WEAK_PASSWORD"
//        }
//        
//        enum EmailVerificationError: String {
//            case userNotFound = "ERROR_USER_NOT_FOUND"
//        }
//        
//        enum DeleteError: String {
//            case requiresRecentLogin = "ERROR_REQUIRES_RECENT_LOGIN"
//        }
//        
//        enum UpdateEmailError: String {
//            case emailAlreadyInUse = "ERROR_EMAIL_ALREADY_IN_USE"
//            case invalidEmail = "ERROR_INVALID_EMAIL"
//            case requiresRecentLogin = "ERROR_REQUIRES_RECENT_LOGIN"
//        }
//        
//        enum UpdatePasswordError: String {
//            case weakPassword = "ERROR_WEAK_PASSWORD"
//            case requiresRecentLogin = "ERROR_REQUIRES_RECENT_LOGIN"
//            case userNotFound = "ERROR_USER_NOT_FOUND"
//        }
//    }
//    
//    //MARK: - CRUD
//    
//    //Creates an account with email
//    func createUser(withEmail email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
//    }
//    
//    //Logs user in with email
//    func loginUser(withEmail email: String, password: String, completion: @escaping(User?, Error?) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
//    }
//    
//    //Signs user out
//    func signOutUser(completion: @escaping(Bool) -> Void) {
//        do {
//            try Auth.auth().signOut()
//            completion(true)
//        } catch {
//            completion(false)
//        }
//    }
//    
//    //Email is sent to reset password
//    func resetPasswordWithEmail(email: String, completion: @escaping (Error?) -> Void) {
//        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
//    }
}
