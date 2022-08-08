//
//  EventChatViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

class EventChatViewController: ObservableObject, IEventChatViewController {

    private var modelController: EventChatModelController? = nil
    
    @Published var event: Event? = nil
    @Published var messages = [Message]()

    init() {
        self.modelController = EventChatModelController(viewController: self)
    }
        
    func downloadData(context: String) {
        self.modelController?.downloadData(context: context)
    }
    
    func isLoaded() -> Bool {
        return event != nil
    }
    
    func sendMessage(context: String, message: String) {
        self.modelController?.sendMessage(text: message, eventID: context, timestamp: Date().timeIntervalSince1970)
    }
    
    func setMessages(messages: [Message]) {
        self.messages = messages
    }
    
    func setEvent(event: Event) {
        self.event = event
    }
}
