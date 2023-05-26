//
//  OAuthCredential.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/24.
//

import Foundation
import Alamofire

struct OAuthCredential : AuthenticationCredential {
    
    let accessToken: String
    
    let refreshToken: String
    
    let expiration: Date
    
    // Require refresh if within 5 minutes of expiration
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 30) > expiration }
    
}
