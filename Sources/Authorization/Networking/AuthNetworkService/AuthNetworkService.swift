//
//  FireBaseAuthHelp.swift
//  diffibleData
//
//  Created by Arman Davidoff on 25.02.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import NetworkServices

protocol AuthNetworkServiceProtocol {
    func phoneNumber(_ number: String, handler: @escaping (Result<String, Error>) -> Void)
    func codeConfirmation(verificationID: String, code: String, handler: @escaping (Result<String, Error>) -> Void)
    func register(email: String, password: String, handler: @escaping (Result<String, Error>) -> Void)
    func login(email: String, password: String, handler: @escaping (Result<String, Error>) -> Void)
    func signOut(completion: @escaping (Error?) -> ())
}

//MARK: Auth
final class AuthNetworkService {
    private let authNetworkService: Auth
    private let phoneAuthNetworkService: PhoneAuthProvider
    
    init(authNetworkService: Auth,
         phoneAuthNetworkService: PhoneAuthProvider) {
        self.authNetworkService = authNetworkService
        self.phoneAuthNetworkService = phoneAuthNetworkService
    }
}

extension AuthNetworkService: AuthNetworkServiceProtocol {
    func phoneNumber(_ number: String, handler: @escaping (Result<String, Error>) -> Void) {
        phoneAuthNetworkService.verifyPhoneNumber(number, uiDelegate: nil) { verificationID, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            guard let verificationID = verificationID else { return }
            handler(.success(verificationID))
        }
    }
    
    func codeConfirmation(verificationID: String, code: String, handler: @escaping (Result<String, Error>) -> Void) {
        let credentional = phoneAuthNetworkService.credential(withVerificationID: verificationID, verificationCode: code)
        authNetworkService.signIn(with: credentional) { (result, error) in
            if let error = error {
                handler(.failure(error))
                return
            }
            guard let user = result?.user else { return }
            handler(.success(user.uid))
        }
    }
    
     func register(email: String, password: String, handler: @escaping (Result<String, Error>) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            handler(.failure(ConnectionError.noInternet))
            return
        }
        authNetworkService.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                handler(.failure(error))
                return
            }
            guard let user = result?.user else { return }
            handler(.success(user.uid))
        }
    }
    
     func login(email: String, password: String, handler: @escaping (Result<String, Error>) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            handler(.failure(ConnectionError.noInternet))
            return
        }
        authNetworkService.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                handler(.failure(error))
                return
            }
            guard let user = result?.user else { return }
            handler(.success(user.uid))
        }
    }
    
    func signOut(completion: @escaping (Error?) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            completion((ConnectionError.noInternet))
            return
        }
        try? self.authNetworkService.signOut()
        completion(nil)
    }
}
