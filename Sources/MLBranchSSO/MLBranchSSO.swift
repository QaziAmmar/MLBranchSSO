//
//  File.swift
//
//
//  Created by Qazi Mudassar on 04/08/2023.
//
import UIKit.UIViewController

public enum SSO: String {
    case google
    case apple
    case twitter
    case facebook
}

public protocol SSOAuthentication {
    func fetchSSOToken(with clientID: String , presenter: UIViewController) async throws -> String
    //func logout() could be added if needed
}

public struct SSOAuthenticationFactory {
    public static func createSSOAuthenticaQtion(with type: SSO) -> SSOAuthentication {
        switch type {
        case .google:
            return GoogleSSOManager()
        case .apple:
            return AppleSSOManager()
        default:
            return GoogleSSOManager()
        }
    }
}
