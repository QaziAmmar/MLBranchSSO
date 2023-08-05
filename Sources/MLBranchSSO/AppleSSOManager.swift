//
//  File.swift
//  
//
//  Created by Qazi Mudassar on 04/08/2023.
//

import AuthenticationServices

public final class AppleSSOManager: NSObject {
    
    private var tokenContinuation: CheckedContinuation<String, Error>?
    weak private var viewController: UIViewController?
    
    public override init() {}
    
    private func handleAppleAuthorization() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AppleSSOManager: SSOAuthentication {
    
    public func fetchSSOToken(with clientID: String , presenter: UIViewController) async throws -> String {
        return try await withCheckedThrowingContinuation({ continuation in
            tokenContinuation = continuation
            viewController = presenter
            handleAppleAuthorization()
        })
    }
}

extension AppleSSOManager: ASAuthorizationControllerDelegate {
   
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let codeData = appleIDCredential.authorizationCode, let codeString = String(data: codeData, encoding: .utf8) {
                debugPrint("code string is:\(codeString)")
                tokenContinuation?.resume(returning: codeString)
            } else {
                tokenContinuation?.resume(returning: "")
            }
        default:
            break
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        tokenContinuation?.resume(throwing: error)
    }
}

extension AppleSSOManager: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = viewController?.view.window else {
            fatalError("No window to present the authorization controller")
        }
        return window
    }
}
