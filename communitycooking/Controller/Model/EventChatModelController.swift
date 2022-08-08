//
//  EventChatModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol IEventChatViewController {
    func setEvent(event: Event)
    func setMessages(messages: [Message])
}

class EventChatModelController {
    
    private let viewController: IEventChatViewController
    private var user: User? = nil
    
    init(viewController: IEventChatViewController) {
        self.viewController = viewController
        DatabaseService.getMyself() { result, error in
            if let user = result {
                self.user = user
            }
        }
    }

    func sendMessage(text: String, eventID: String, timestamp: Double) {
        if let user = user {
            DatabaseService.sendMessage(message: Message(context: eventID, timestamp: timestamp, user: user, text: text, documentId: nil)) {_ in}
        }
    }

    func downloadData(context: String) {
        DatabaseService.getMessagesByContext(context: context) { result, error in
            if let messages = result {
                self.viewController.setMessages(messages: messages)
            }
        }

        DatabaseService.getEventById(documentId: context) { result, error in
            if let event = result {
                self.viewController.setEvent(event: event)
            }
        }
    }
}
