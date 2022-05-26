//
//  AuthManager.swift
//  
//
//  Created by Арман Чархчян on 13.04.2022.
//

import NetworkServices
import Foundation
import ModelInterfaces
import Services
import Managers
import Swinject

protocol AuthManagerProtocol {
    func register(email: String,
                  password: String,
                  handler: @escaping (Result<Void, Error>) -> Void)
    func login(email: String,
               password: String,
               handler: @escaping (Result<AccountModelProtocol, AuthManagerError>) -> Void)
}

final class AuthManager {
    
    private let authService: AuthNetworkServiceProtocol
    private let profileService: ProfileInfoNetworkServiceProtocol
    private let accountInfoService: AccountContentNetworkServiceProtocol
    private let quickAccessManager: QuickAccessManagerProtocol
    private let container: Container
    
    init(authService: AuthNetworkServiceProtocol,
         quickAccessManager: QuickAccessManagerProtocol,
         profileService: ProfileInfoNetworkServiceProtocol,
         accountInfoService: AccountContentNetworkServiceProtocol,
         container: Container) {
        self.authService = authService
        self.quickAccessManager = quickAccessManager
        self.profileService = profileService
        self.accountInfoService = accountInfoService
        self.container = container
    }
}

extension AuthManager: AuthManagerProtocol {
    
    func register(email: String,
                         password: String,
                         handler: @escaping (Result<Void, Error>) -> Void) {
        authService.register(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let userID):
                self?.register(userID: userID)
                handler(.success(()))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func login(email: String, password: String, handler: @escaping (Result<AccountModelProtocol, AuthManagerError>) -> Void) {
        authService.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let id):
                self?.register(userID: id)
                self?.profileInfo(accountID: id, handler: handler)
            case .failure(let error):
                handler(.failure(.another(error: error)))
            }
        }
        
    }
}

private extension AuthManager {
    
    enum Names: String {
        case accountID
    }
    
    func register(userID: String) {
        container.register(String.self,
                           name: Names.accountID.rawValue) { _ in userID }
    }
    
    func profileInfo(accountID: String, handler: @escaping (Result<AccountModelProtocol, AuthManagerError>) -> Void) {
        var profile: ProfileModelProtocol?
        var blockedIDs: [String]?
        var friendIDs: [String]?
        var requestIDs: [String]?
        var waitingsIDs: [String]?
        
        let group = DispatchGroup()
        group.enter()
        profileService.getProfileInfo(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let model):
                profile = ProfileModel(profile: model)
            case .failure:
                break
            }
        }
        group.enter()
        accountInfoService.getBlockedIds(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                blockedIDs = ids
            case .failure:
                break
            }
        }
        group.enter()
        accountInfoService.waitingIDs(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                waitingsIDs = ids
            case .failure:
                break
            }
        }
        group.enter()
        accountInfoService.requestIDs(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                requestIDs = ids
            case .failure:
                break
            }
        }
        group.enter()
        accountInfoService.friendIDs(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                friendIDs = ids
            case .failure:
                break
            }
        }
        group.notify(queue: .main) {
            guard let profile = profile,
                  let blockedIDs = blockedIDs,
                  let waitingsIDs = waitingsIDs,
                  let requestIDs = requestIDs,
                  let friendIDs = friendIDs else {
                handler(.failure(.profile(value: .emptyProfile)))
                return
            }
            let account = AccountModel(profile: profile, blockedIDs: Set(blockedIDs), friendIds: Set(friendIDs), waitingsIds: Set(waitingsIDs), requestIds: Set(requestIDs))
            self.quickAccessManager.userID = accountID
            handler(.success(account))
        }
    }
}
