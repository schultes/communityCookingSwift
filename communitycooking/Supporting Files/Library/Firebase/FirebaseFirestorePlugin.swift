//
//  FirestorePlugin.swift
//  PluginsForIOSLibrary
//
//  Created by FMA1 on 25.05.21.
//  Copyright © 2021 FMA1. All rights reserved.
//

import Foundation
import Firebase

/**
 Diese Klasse enthält neben der ID des Dokuments und dem Namen der zugehörigen Collection,
 auch die gespeicherten Daten des Dokuments selbst
 - Parameter documentId: ID des Dokuments
 - Parameter collectionName: Name der zugehörigen Collection
 - Parameter data: Die gespeicherten Daten des Dokuments als Key-Value-Paare
 */
public struct TPFirebaseFirestoreDocument {
    /// ID des Dokuments
    public let documentId: String
    /// Name der zugehörigen Collection
    public let collectionName: String
    /// Die gespeicherten Daten des Dokuments als Key-Value-Paare
    public var data: [String: Any]
}

/**
 Mit dieser Klasse lässt sich ein Query für Firestore zusammensetzen.
 Mittels dieses Querys lassen sich angefragte Dokumente in ihrem Umfang eingrenzen.
 */
public class TPFirebaseFirestoreQueryBuilder {
    /// Der Name der Collection von Firestore
    public let collectionName: String
    private var query: Query
    private let db = Firestore.firestore()
    
    /**
     Konstruktor
     - Parameter collectionName: Der Name der Collection von Firestore
     */
    public init(collectionName: String) {
        self.collectionName = collectionName
        self.query = db.collection(collectionName)
    }
    
    /**
     Filtert eine Collection nach Dokumenten, bei denen das Array mit dem Namen `field` den Wert `value` enthält
     - Parameter field: Attributname des Arrays
     - Parameter value: Wert, der im Array enthalten sein muss
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func whereArrayContains(field: String, value: Any) -> TPFirebaseFirestoreQueryBuilder {
        query = query.whereField(field, arrayContains: value)
        return self
    }
    
    /**
     Filtert eine Collection nach Dokumenten, bei denen das Array mit dem Namen `field` ein oder mehrere Elemente des Arrays `value` enthält
     - Parameter field: Attributname des Arrays
     - Parameter value: Array von möglichen Werten in dem `field`-Array
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func whereArrayContainsAny(field: String, value: [Any]) -> TPFirebaseFirestoreQueryBuilder {
        query.whereField(field, arrayContainsAny: value)
        return self
    }
    
    /**
     Filtert eine Collection nach Dokumenten, bei denen der Wert des Feldes `field` dem übergebenen Wert `value` entspricht
     - Parameter field: Attributname des Feldes
     - Parameter value: Der zu findende Wert
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func whereEqualTo(field: String, value: Any) -> TPFirebaseFirestoreQueryBuilder {
        query = query.whereField(field, isEqualTo: value)
        return self
    }
    
    /**
     Filtert eine Collection nach Dokumenten, bei denen der Wert des Feldes `field` explizit nicht dem übergebenen Wert `value` entspricht
     - Parameter field: Attributname des Feldes
     - Parameter value: Der Wert, den das Feld `field` nicht haben darf
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func whereNotEqualTo(field: String, value: Any) -> TPFirebaseFirestoreQueryBuilder {
        query = query.whereField(field, isNotEqualTo: value)
        return self
    }
    
    /**
     Filtert eine Collection nach Dokumenten, bei denen der Wert des Feldes `field` in der Liste `value` enthalten ist
     - Parameter field: Attributname des Feldes
     - Parameter value: Liste von möglichen Werten, die das Feld `field` haben darf
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func whereIn(field: String, value: [Any]) -> TPFirebaseFirestoreQueryBuilder {
        query = query.whereField(field, in: value)
        return self
    }
    
    /**
     Filtert eine Collection nach Dokumenten, bei denen der Wert des Feldes `field` explizit nicht in der Liste `value` enthalten ist
     - Parameter field: Attributname des Feldes
     - Parameter value: Liste von möglichen Werten, die das Feld `field` nicht haben darf
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func whereNotIn(field: String, value: [Any]) -> TPFirebaseFirestoreQueryBuilder {
        query = query.whereField(field, notIn: value)
        return self
    }
    
    /**
     Filtert eine Collection nach Dokumenten, bei denen der Wert des Feldes `field` größer dem Wert `value` ist
     - Parameter field: Attributname des Feldes
     - Parameter value: Der zu vergleichende Wert
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func whereGreaterThan(field: String, value: Any) -> TPFirebaseFirestoreQueryBuilder {
        query = query.whereField(field, isGreaterThan: value)
        return self
    }
    
    /**
     Filtert eine Collection nach Dokumenten, bei denen der Wert des Feldes `field` größer oder gleich dem Wert `value` ist
     - Parameter field: Attributname des Feldes
     - Parameter value: Der zu vergleichende Wert
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func whereGreaterThanOrEqualTo(field: String, value: Any) -> TPFirebaseFirestoreQueryBuilder {
        query = query.whereField(field, isGreaterThanOrEqualTo: value)
        return self
    }
    
    /**
     Filtert eine Collection nach Dokumenten, bei denen der Wert des Feldes `field` kleiner dem Wert `value` ist
     - Parameter field: Attributname des Feldes
     - Parameter value: Der zu vergleichende Wert
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func whereLessThan(field: String, value: Any) -> TPFirebaseFirestoreQueryBuilder {
        query = query.whereField(field, isLessThan: value)
        return self
    }
    
    /**
     Filtert eine Collection nach Dokumenten, bei denen der Wert des Feldes `field` kleiner oder gleich dem Wert `value` ist
     - Parameter field: Attributname des Feldes
     - Parameter value: Der zu vergleichende Wert
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func whereLessThanOrEqualTo(field: String, value: Any) -> TPFirebaseFirestoreQueryBuilder {
        query = query.whereField(field, isLessThanOrEqualTo: value)
        return self
    }
    
    /**
     Sortiert die Ergebnismenge nach dem Feld `field`
     Default: Aufsteigende Sortierung)
     - Parameter field: Attributname des Feldes
     - Parameter descending: Legt fest, ob die Ergebnismenge absteigend sortiert werden soll
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func orderBy(field: String, descending: Bool = false) -> TPFirebaseFirestoreQueryBuilder {
        query = query.order(by: field, descending: descending)
        return self
    }
    
    /**
     Begrenzt die Ergebnismenge in ihrem Umfang
     - Parameter limit: Maximale Anzahl der Elemente in der Ergebnismenge
     - Returns: TPFirebaseFirestoreQueryBuilder
     */
    public func limit(limit: Int) -> TPFirebaseFirestoreQueryBuilder {
        query = query.limit(to: limit)
        return self
    }
    
    fileprivate func getCollectionName() -> String {
        return collectionName
    }
    
    fileprivate func getQuery() -> Query {
        return query
    }
}

/**
 * Diese Klasse stellt statische Methoden für die Verwendung von Firestore bereit.
 */
public struct TPFirebaseFirestore {
    private static let db = Firestore.firestore()
    
    /**
     Fügt ein neues Dokument mit den angegebenen Daten in die angegebene Collection ein
     - Parameter collectionName: Name der Collection
     - Parameter data: Die einzufügenden Daten als Key-Value-Paare
     - Parameter callback: Callback für Ergebnisrückgabe
     - Parameter result: Erstelltes Dokument (im Erfolgsfall)
     - Parameter error: Fehlermeldung (bei Misserfolg)
     # Reference TPFirebaseFirestoreDocument
     */
    public static func addDocument(
        collectionName: String,
        data: [String: Any],
        callback: @escaping (_ result: TPFirebaseFirestoreDocument?, _ error: String?) -> Void
    ) {
        var reference: DocumentReference? = nil
        reference = db.collection(collectionName).addDocument(data: data) {
            err in
            if let err = err {
                callback(nil, "\(err.localizedDescription)")
            } else {
                getDocument(collectionName: collectionName, documentId: reference!.documentID, callback: callback)
            }
        }
    }
    
    /**
     Erstellt oder überschreibt ein Dokument mit der angegebenen ID und Daten in der angegebenen Collection
     - Parameter collectionName: Name der Collection
     - Parameter documentId: ID des Dokuments
     - Parameter data: Die einzufügenden Daten als Key-Value-Paare
     - Parameter callback: Callback für Ergebnisrückgabe (nur bei Misserfolg)
     - Parameter error: Fehlermeldung (bei Misserfolg)
     */
    public static func setDocument(
        collectionName: String,
        documentId: String,
        data: [String: Any],
        callback: @escaping (_ error: String?)  -> Void
    ) {
        db.collection(collectionName).document(documentId).setData(data) {
            err in
            if let err = err {
                callback("\(err.localizedDescription)")
            } else {
                callback(nil)
            }
        }
    }
    
    /**
     Gibt das Dokument mit der angefragten ID aus der angegebenen Collection zurück.
     - Parameter collectionName: Name der Collection
     - Parameter documentId: ID des Dokuments
     - Parameter callback: Callback für Ergebnisrückgabe
     - Parameter result: Angefragtes Dokument (im Erfolgsfall)
     - Parameter error: Fehlermeldung (bei Misserfolg)
     # Reference TPFirebaseFirestoreDocument
     */
    public static func getDocument(
        collectionName: String,
        documentId: String,
        callback: @escaping (_ result: TPFirebaseFirestoreDocument?, _ error: String?) -> Void
    ) {
        var reference: DocumentReference? = nil
        
        reference = db.collection(collectionName).document(documentId)
        reference?.getDocument { (document, error) in
            if let document = document {
                let dataDescription = document.data()
                let tpDocument = TPFirebaseFirestoreDocument(documentId: reference!.documentID, collectionName: collectionName, data: dataDescription ?? [String: Any]())
                callback(tpDocument, nil)
            }
            
            if error != nil {
                callback(nil, "\(error!.localizedDescription)")
            }
        }
    }
    
    /**
     Gibt alle Dokumente der angegebenen Collection zurück.
     - Parameter collectionName: Name der Collection
     - Parameter callback: Callback für Ergebnisrückgabe
     - Parameter result: Liste aller Dokumente der angegebenen Collection (im Erfolgsfall)
     - Parameter error: Fehlermeldung (bei Misserfolg)
     # Reference TPFirebaseFirestoreDocument
     */
    public static func getDocuments(
        collectionName: String,
        callback: @escaping (_ result: [TPFirebaseFirestoreDocument]?, _ error: String?) -> Void
    ) {
        db.collection(collectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                callback(nil, "\(error.localizedDescription)")
            } else {
                var documentList = [TPFirebaseFirestoreDocument]()
                for document in querySnapshot!.documents {
                    documentList.append(TPFirebaseFirestoreDocument(documentId: document.documentID, collectionName: collectionName, data: document.data()))
                }
                callback(documentList, nil)
            }
        }
    }
    
    /**
     Gibt alle Dokumente zurück, die den gesetzten Kriterien des Filters `query` entsprechen.
     - Parameter queryBuilder: Instanz des TPFirebaseFirestoreQueryBuilder, der Filterkriterien festlegt
     - Parameter callback: Callback für Ergebnisrückgabe
     - Parameter result: Liste der Dokumente, die den Filterkriterien entsprechen (im Erfolgsfall)
     - Parameter error: Fehlermeldung (bei Misserfolg)
     # Reference TPFirebaseFirestoreQueryBuilder
     # Reference TPFirebaseFirestoreDocument
     */
    public static func getDocuments(
        queryBuilder: TPFirebaseFirestoreQueryBuilder,
        callback: @escaping (_ result: [TPFirebaseFirestoreDocument]?, _ error: String?) -> Void
    ) {
        queryBuilder.getQuery().getDocuments { (querySnapshot, error) in
            if let error = error {
                callback(nil, "\(error.localizedDescription)")
            } else {
                var documentList = [TPFirebaseFirestoreDocument]()
                for document in querySnapshot!.documents {
                    documentList.append(TPFirebaseFirestoreDocument(documentId: document.documentID, collectionName: queryBuilder.getCollectionName(), data: document.data()))
                }
                callback(documentList, nil)
            }
        }
    }
    
    /**
     Updatet die in `data` enthaltenen Felder des Dokuments mit der ID `documentId`. Wenn das Dokument nicht existiert, wird ein Fehler zurückgegeben.
     - Parameter collectionName: Name der Collection
     - Parameter documentId: ID des Dokuments
     - Parameter data: Die aktualisierten Daten als Key-Value-Paare
     - Parameter callback: Callback für Ergebnisrückgabe (nur bei Misserfolg)
     - Parameter error: Fehlermeldung (bei Misserfolg)
     */
    public static func updateDocument(
        collectionName: String,
        documentId: String,
        data: [String: Any],
        callback: ((_ error: String?)  -> Void)? = nil
    ) {
        db.collection(collectionName).document(documentId).updateData(data) { err in
            if callback != nil {
                if err != nil {
                    callback!("\(err!.localizedDescription)")
                } else {
                    callback!(nil)
                }
            }
        }
    }
    
    /**
     Löscht das Dokument mit der angegebenen ID aus der angegebenen Collection
     - Parameter collectionName: Name der Collection
     - Parameter documentId: ID des Dokuments
     - Parameter callback: Callback für Ergebnisrückgabe (nur bei Misserfolg)
     - Parameter error: Fehlermeldung (bei Misserfolg)
     */
    public static func deleteDocument(
        collectionName: String,
        documentId: String,
        callback: ((_ error: String?)  -> Void)? = nil
    ) {
        db.collection(collectionName).document(documentId).delete() { err in
            if callback != nil {
                if err != nil {
                    callback!("\(err!.localizedDescription)")
                } else {
                    callback!(nil)
                }
            }
        }
    }
    
    /**
     Fügt einer angegebenen Collection einen SnapshotListener hinzu, der mit Hilfe des Callbacks über Änderungen in der Collection informiert
     - Parameter collectionName: Name der Collection
     - Parameter callback: Callback für Ergebnisrückgabe beim Hinzufügen des SnapshotListeners und bei später auftretenden Änderungen
     - Parameter result: Liste aller Dokumente der Collection (im Erfolgsfall)
     - Parameter error: Fehlermeldung (bei Misserfolg)
     # Reference TPFirebaseFirestoreDocument
     */
    public static func addCollectionSnapshotListener(
        collectionName: String,
        callback: @escaping (_ result: [TPFirebaseFirestoreDocument]?, _ error: String?) -> Void
    ) {
        db.collection(collectionName).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                callback(nil, "\(error.localizedDescription)")
            } else {
                var documentList = [TPFirebaseFirestoreDocument]()
                for document in querySnapshot!.documents {
                    documentList.append(TPFirebaseFirestoreDocument(documentId: document.documentID, collectionName: collectionName, data: document.data()))
                }
                callback(documentList, nil)
            }
        }
        
    }
    
    /**
     Fügt einer im QueryBuilder angegebenen Collection einen SnapshotListener hinzu, der mit Hilfe des Callbacks über Änderungen in der Collection informiert, die den gesetzten Kriterien des Filters `query` entsprechen.
     - Parameter queryBuilder: Instanz des TPFirebaseFirestoreQueryBuilder, der Filterkriterien festlegt
     - Parameter callback: Callback für Ergebnisrückgabe beim Hinzufügen des SnapshotListeners und bei später auftretenden Änderungen
     - Parameter result: Liste aller Dokumente der Collection, die den Filterkriterien entsprechen (im Erfolgsfall)
     - Parameter error: Fehlermeldung (bei Misserfolg)
     # Reference TPFirebaseFirestoreQueryBuilder
     # Reference TPFirebaseFirestoreDocument
     */
    public static func addCollectionSnapshotListener(
        queryBuilder: TPFirebaseFirestoreQueryBuilder,
        callback: @escaping (_ result: [TPFirebaseFirestoreDocument]?, _ error: String?) -> Void
    ) {
        queryBuilder.getQuery().addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                callback(nil, "\(error.localizedDescription)")
            } else {
                var documentList = [TPFirebaseFirestoreDocument]()
                for document in querySnapshot!.documents {
                    documentList.append(TPFirebaseFirestoreDocument(documentId: document.documentID, collectionName: queryBuilder.getCollectionName(), data: document.data()))
                }
                callback(documentList, nil)
            }
        }
    }
    
    /**
     Fügt einem Dokument mit der angegebenen ID aus der angegebenen Collection einen SnapshotListener hinzu, der mit Hilfe des Callbacks über Änderungen des Dokuments informiert
     - Parameter collectionName: Name der Collection
     - Parameter documentId: ID des Dokuments
     - Parameter callback: Callback für Ergebnisrückgabe beim Hinzufügen des SnapshotListeners und bei später auftretenden Änderungen
     - Parameter result: Angefragtes Dokument (im Erfolgsfall)
     - Parameter error: Fehlermeldung (bei Misserfolg)
     # Reference TPFirebaseFirestoreDocument
     */
    public static func addDocumentSnapshotListener(
        collectionName: String,
        documentId: String,
        callback: @escaping (_ result: TPFirebaseFirestoreDocument?, _ error: String?) -> Void
    ) {
        db.collection(collectionName).document(documentId).addSnapshotListener { (documentSnapshot, error) in
            if let err = error {
                callback(nil, "\(err.localizedDescription)")
            } else {
                let dataDescription = documentSnapshot!.data()
                let tpDocument = TPFirebaseFirestoreDocument(documentId: documentId, collectionName: collectionName, data: dataDescription ?? [String: Any]())
                callback(tpDocument, nil)
            }
        }
    }
}
