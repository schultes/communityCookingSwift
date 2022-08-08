//
//  EventEditViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

class EventEditViewController: ObservableObject, IEventEditViewController {
    
    private var modelController: EventEditModelController? = nil

    @Published var user: User? = nil
    
    @Published var documentId: String? = nil
    @Published var timestamp = Date()
    
    @Published var location: Location? = nil
    @Published var isPublic: Bool = true
    
    @Published var title = ""
    @Published var description = ""
    
    @Published var recipe: Recipe? = nil
        
    @Published var requested = [User]()
    @Published var participating = [User]()
    
    @Published var errorShowing = false
    @Published var errorMessage = ""
    
    private var locationManager: TPLocationListener? = nil
    
    init() {
        self.modelController = EventEditModelController(viewController: self)
    }
    
    func downloadData(eventId: String?) {
        self.modelController?.downloadData(eventID: eventId)
    }
    
    func onSaveClicked() {
        
        self.title = self.title.trimming(spaces: .leadingAndTrailing)
        self.description = self.description.trimming(spaces: .leadingAndTrailing)
        
        if !self.title.isEmpty && !self.description.isEmpty && self.location != nil && self.recipe != nil {
            self.modelController?.onSaveClicked(timestamp: self.timestamp.timeIntervalSince1970, owner: self.user!, location: self.location!, isPublic: self.isPublic, title: self.title, description: self.description, recipe: self.recipe!, requested: self.requested, participating: self.participating, documentId: self.documentId)
        } else {
            self.errorMessage = "Bitte füllen Sie alle benötigten Informationen aus!"
            self.errorShowing = true
        }
    }
    
    func onDeleteClicked() {
        if self.documentId != nil {
            self.modelController?.onDeleteClicked(documentId: self.documentId!)
        }
    }
    
    func setRecipe(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func setData(event: Event) {
        self.user = event.owner
        self.documentId = event.documentId
        self.timestamp = Date(timeIntervalSince1970: event.timestamp)
        self.location = event.location
        self.isPublic = event.isPublic
        self.title = event.title
        self.description = event.description
        self.recipe = event.recipe
        self.requested = event.requested
        self.participating = event.participating
    }
    
    func setDataNewEvent(user: User) {
        self.user = user
        self.locationManager = TPLocationListener()
        self.locationManager!.setCallback() { location in
            self.location = Location(timestamp: location.time, latitude: location.latitude, longitude: location.longitude)
        }
        self.locationManager!.getCurrentLocation()
    }
    
    func findCurrentLocation() {
        self.locationManager = TPLocationListener()
        self.locationManager!.setCallback() { location in
            self.location = Location(timestamp: location.time, latitude: location.latitude, longitude: location.longitude)
        }
        self.locationManager!.getCurrentLocation()
    }
    
    func isLoaded() -> Bool {
        return user != nil
    }
    
    func exitActivity() {
        NavigationStack.current?.pop()
    }
    
    func showErrorMessage(message: String) {
        self.errorMessage = message
        self.errorShowing = true
    }
}
