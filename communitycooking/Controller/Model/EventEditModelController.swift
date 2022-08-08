//
//  EventEditModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol IEventEditViewController {
    func setData(event: Event)
    func setDataNewEvent(user: User)
    func exitActivity()
    func showErrorMessage(message: String)
}

class EventEditModelController {
    
    private let viewController: IEventEditViewController
    
    init(viewController: IEventEditViewController) {
        self.viewController = viewController
    }
    
    func downloadData(eventID: String?) {
        if eventID != nil {
            DatabaseService.getEventById(documentId: eventID!) {
                result, error in
                if let event = result {
                    self.viewController.setData(event: event)
                }

                if let message = error {
                    self.viewController.showErrorMessage(message: message)
                }
            }
        } else {
            DatabaseService.getMyself {
                result, error in
                if let user = result {
                    self.viewController.setDataNewEvent(user: user)
                }

                if let message = error {
                    self.viewController.showErrorMessage(message: message)
                }
            }
        }
    }

    func onSaveClicked(timestamp: Double, owner: User, location: Location, isPublic: Bool, title: String, description: String, recipe: Recipe, requested: [User], participating: [User], documentId: String?) {
        
        if documentId == nil {
            DatabaseService.setEvent(event: Event(timestamp: timestamp, owner: owner, location: location, isPublic: isPublic, title: title, description: description, recipe: recipe, requested: requested, participating: participating, documentId: documentId)) { error in
                
                if let message = error {
                    self.viewController.showErrorMessage(message: message)
                } else {
                    self.viewController.exitActivity()
                }
            }
        } else {
            DatabaseService.getEventById(documentId: documentId!) { result, error in
                
                if let event = result {
                    DatabaseService.setEvent(event: Event(timestamp: timestamp, owner: owner, location: location, isPublic: isPublic, title: title, description: description, recipe: recipe, requested: requested.filter { user in event.requested.contains {temp in temp.documentId == user.documentId} }, participating: participating.filter { user in event.participating.contains{temp in temp.documentId == user.documentId} || event.requested.contains{temp in temp.documentId == user.documentId} }, documentId: event.documentId)) { error in
                        
                        if let message = error {
                            self.viewController.showErrorMessage(message: message)
                        } else {
                            self.viewController.exitActivity()
                        }
                    }
                }

                if let message = error {
                    self.viewController.showErrorMessage(message: message)
                }
            }
        }
    }

    func onDeleteClicked(documentId: String) {
        DatabaseService.deleteEventById(documentId: documentId) { error in
            if let message = error {
                self.viewController.showErrorMessage(message: message)
            } else {
                self.viewController.exitActivity()
            }
        }
    }
}
