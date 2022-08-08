//
//  MainViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

class MainViewController: ObservableObject, IModelViewController {
    
    private var modelController: MainModelController? = nil
    
    @Published var user: User?
    @Published var userLocation: Location?
    
    @Published var nearbyEvents = [Event]()
    @Published var requestedEvents = [Event]()
    @Published var participatingEvents = [Event]()
    
    private var locationManager: TPLocationListener? = nil
    
    init() {
        self.modelController = MainModelController(viewController: self)
    }
    
    func downloadData() {
        self.modelController?.downloadData()
    }
    
    func setRequestedEvents(events: [Event]) {
        self.requestedEvents = events
    }
    
    func setParticipatingEvents(events: [Event]) {
        self.participatingEvents = events
    }
    
    func setNearEvents(events: [Event]) {
        self.nearbyEvents = events
    }
    
    func setUser(user: User) {
        self.user = user
        
        self.locationManager = TPLocationListener()
        self.locationManager!.setCallback() { location in
            self.userLocation = Location(timestamp: location.time, latitude: location.latitude, longitude: location.longitude)
            self.modelController?.downloadLocationBasedData(user: user, location: self.userLocation!)
        }
        self.locationManager!.getCurrentLocation()
    }
    
    func setRequestForEvent(event: Event) {
        self.modelController?.setRequestForEvent(user: user!, event: event)
    }
    
    func removeRequestForEvent(event: Event) {
        self.modelController?.removeRequestForEvent(user: user!, event: event)
    }
    
    func signOut() {
        AuthenticationService.signOut()
        NavigationStack.current?.pop(to: .root)
    }
    
    func showErrorMessage(message: String) {
        print(message)
    }
}
