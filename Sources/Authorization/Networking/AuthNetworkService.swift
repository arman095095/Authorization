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

public protocol AuthNetworkServiceProtocol {
    func register(email: String, password: String, handler: @escaping (Result<String, Error>) -> Void)
    func login(email: String, password: String, handler: @escaping (Result<String, Error>) -> Void)
    func signOut(completion: @escaping (Error?) -> ())
}

//MARK: Auth
final class AuthNetworkService {
    private let authNetworkService: Auth
    
    init(authNetworkService: Auth) {
        self.authNetworkService = authNetworkService
    }
}

extension AuthNetworkService: AuthNetworkServiceProtocol {
    public func register(email: String, password: String, handler: @escaping (Result<String, Error>) -> Void) {
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
    
    public func login(email: String, password: String, handler: @escaping (Result<String, Error>) -> Void) {
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
    
    public func signOut(completion: @escaping (Error?) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            completion((ConnectionError.noInternet))
            return
        }
        try? self.authNetworkService.signOut()
        completion(nil)
    }
}
