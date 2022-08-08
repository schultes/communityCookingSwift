//
//  EventShowViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

class EventShowViewController: ObservableObject, IEventShowViewController {
    
    private var modelController: EventShowModelController? = nil
        
    @Published var userId: String?
    @Published var event: Event?
        
    @Published var errorShowing = false
    @Published var errorMessage = ""
    
    init() {
        self.modelController = EventShowModelController(viewController: self)
    }
        
    func downloadData(eventId: String) {
        self.modelController?.downloadData(eventId: eventId)
    }
    
    func leaveEvent() {
        self.modelController?.leaveEvent(event: event!)
    }
    
    func setData(userId: String, event: Event) {
        self.userId = userId
        self.event = event
    }
    
    func isLoaded() -> Bool {
        return userId != nil && event != nil
    }
    
    func exitActivity() {
        NavigationStack.current?.pop()
    }
    
    func showErrorMessage(message: String) {
        self.errorMessage = message
        self.errorShowing = true
    }
}
