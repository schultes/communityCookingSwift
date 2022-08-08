//
//  UserCacheService.swift
//  communitycooking
//
//  Created by FMA2 on 31.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Firebase

class UserCacheService {
    
    static private var instance = UserCacheService()
    static func getInstance() -> UserCacheService {
        return instance
    }
    
    private var cache = [User]()
        
    init() {
        addSnapshotListener()
    }
    
    private func addSnapshotListener() {
        TPFirebaseFirestore.addCollectionSnapshotListener(collectionName: User.COLLECTION_NAME, callback: { result, error in
            if let documents = result {
                self.cache = documents.filter { document in self.cache.contains { cachedUser in cachedUser.documentId == document.documentId }}.compactMap { document in User.toObject(documentId: document.documentId, map: document.data )}
            }
        })
    }
    
    func getUserByDocumentId(documentId: String) -> User? {
        return cache.first {user in user.documentId == documentId}
    }

    func getUserByUsername(username: String) -> User? {
        return cache.first {user in user.username == username}
    }

    func getUsersByUsernames(usernames: [String]) -> [User] {
        return cache.filter {element in usernames.contains(element.username)}
    }

    func setUser(user: User) {
        cache.removeAll {temp in temp.documentId == user.documentId}
        cache.append(user)
    }

    func setUsers(users: [User]) {
        users.forEach {
            user in
            cache.removeAll {temp in temp.documentId == user.documentId}
            cache.append(user)
        }
    }
}
