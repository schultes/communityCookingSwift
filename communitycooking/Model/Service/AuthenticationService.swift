class AuthenticationService {
    static func signUp(email: String, password: String, username: String, callback: @escaping (TPFirebaseAuthenticationUser?, String?) -> ()) {
        TPFirebaseAuthentication.signUp(email: email, password: password, displayName: username) { result, error in
            if let user = result {
                callback(user, nil)
            }

            if let message = error {
                callback(nil, message)
            }
        }
    }

    static func signIn(email: String, password: String, callback: @escaping (TPFirebaseAuthenticationUser?, String?) -> ()) {
        TPFirebaseAuthentication.signIn(email: email, password: password) { result, error in
            if let user = result {
                callback(user, nil)
            }

            if let message = error {
                callback(nil, message)
            }
        }
    }

    static func signOut() {
        TPFirebaseAuthentication.signOut()
    }
}
