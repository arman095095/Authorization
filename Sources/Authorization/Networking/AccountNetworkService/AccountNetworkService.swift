//
//  AccountService.swift
//  
//
//  Created by Арман Чархчян on 10.04.2022.
//

import Foundation
import FirebaseFirestore
import ModelInterfaces
import UIKit
import NetworkServices

protocol AccountNetworkServiceProtocol {
    func getBlockedIds(accountID: String,
                       completion: @escaping (Result<[String],Error>) -> Void)
    
}

final class AccountNetworkService {
    
    private let networkServiceRef: Firestore

    private var usersRef: CollectionReference {
        return networkServiceRef.collection(URLComponents.Paths.users.rawValue)
    }
    
    init(networkService: Firestore) {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        networkService.settings = settings
        self.networkServiceRef = networkService
    }
}

extension AccountNetworkService: AccountNetworkServiceProtocol {
    
    public func getBlockedIds(accountID: String, completion: @escaping (Result<[String], Error>) -> Void) {
        var ids: [String] = []
        usersRef.document(accountID).collection(ProfileURLComponents.Paths.blocked.rawValue).getDocuments { (query, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let query = query else { return }
            query.documents.forEach { doc in
                if let id = doc.data()[ProfileURLComponents.Parameters.id.rawValue] as? String {
                    ids.append(id)
                }
            }
            completion(.success(ids))
        }
    }
}
