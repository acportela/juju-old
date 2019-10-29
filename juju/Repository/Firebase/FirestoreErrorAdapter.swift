//
//  FirestoreErrorAdapter.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FirestoreErrorAdapter {

    func getErrorFromCode(_ code: FirestoreErrorCode) -> RepositoryError {

        switch code {

        case .permissionDenied, .unauthenticated: return .unauthorized
        case .resourceExhausted: return .resourceExausted
        case .invalidArgument: return .malformedQuery
        case .alreadyExists: return .entryAlreadyExists
        case .deadlineExceeded: return .network
        default: return .unknown

        }
    }
}
