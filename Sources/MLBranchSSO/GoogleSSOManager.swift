//
//  File.swift
//  
//
//  Created by Qazi Mudassar on 04/08/2023.
//

import GoogleSignIn

public struct GoogleSSOManager: SSOAuthentication {
    
    public init() {}
    
    @MainActor
    public func fetchSSOToken(with clientID: String , presenter: UIViewController) async throws -> String {
        
        try await withCheckedThrowingContinuation { continuation in
            let completionHandler: (GIDGoogleUser?, Error?) -> Void = { signInResult, error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                if let idToken = signInResult?.authentication.idToken {
                    continuation.resume(returning: idToken)
                }
            }
            
            
            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                GIDSignIn.sharedInstance.restorePreviousSignIn(callback: completionHandler)
            }else {
                
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.signIn(with: config, presenting: presenter, callback: completionHandler)
            }
        }
    }
}
