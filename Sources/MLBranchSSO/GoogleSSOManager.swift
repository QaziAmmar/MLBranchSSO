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
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.signIn(with: config, presenting: presenter) { signInResult, error in
                if let error {
                    return continuation.resume(throwing: error)
                }
                guard let signInResult = signInResult else { return }
                guard let idToken = signInResult.authentication.idToken else { return }
                continuation.resume(returning: idToken)
            }
        }
    }
}

