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

public protocol AuthManagerProtocol {
    func register(email: String,
                  password: String,
                  handler: @escaping (Result<Void, Error>) -> Void)
    func login(email: String,
               password: String,
               handler: @escaping (Result<AccountModelProtocol, AuthManagerError>) -> Void)
}

public final class AuthManager {
    
    private let authService: AuthServiceProtocol
    private let accountService: AccountServiceProtocol
    private let remoteStorageService: RemoteStorageServiceProtocol
    private let profileService: ProfilesServiceProtocol
    private let requestsService: RequestsServiceProtocol
    private let quickAccessManager: QuickAccessManagerProtocol
    private let container: Container
    
    public init(authService: AuthServiceProtocol,
                accountService: AccountServiceProtocol,
                remoteStorage: RemoteStorageServiceProtocol,
                quickAccessManager: QuickAccessManagerProtocol,
                profileService: ProfilesServiceProtocol,
                requestsService: RequestsServiceProtocol,
                container: Container) {
        self.authService = authService
        self.accountService = accountService
        self.remoteStorageService = remoteStorage
        self.quickAccessManager = quickAccessManager
        self.profileService = profileService
        self.requestsService = requestsService
        self.container = container
    }
}

extension AuthManager: AuthManagerProtocol {
    
    public func register(email: String,
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
    
    public func login(email: String, password: String, handler: @escaping (Result<AccountModelProtocol, AuthManagerError>) -> Void) {
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
    
    func register(userID: String) {
        container.register(String.self, name: "accountID" ,factory: { _ in
            userID
        })
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
        accountService.getBlockedIds(accountID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                blockedIDs = ids
            case .failure:
                break
            }
        }
        group.enter()
        requestsService.waitingIDs(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                waitingsIDs = ids
            case .failure:
                break
            }
        }
        group.enter()
        requestsService.requestIDs(userID: accountID) { result in
            defer { group.leave() }
            switch result {
            case .success(let ids):
                requestIDs = ids
            case .failure:
                break
            }
        }
        group.enter()
        requestsService.friendIDs(userID: accountID) { result in
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
