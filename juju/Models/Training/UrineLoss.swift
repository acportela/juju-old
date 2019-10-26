//
//  UrineLoss.swift
//  juju
//
//  Created by Antonio Rodrigues on 24/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

enum UrineLoss: Int, RawRepresentable, Codable {

    case none
    case low
    case moderate
    case high

    static let fallback = UrineLoss.none

    var destription: String {

        switch self {

        case .none: return "nenhuma"

        case .low: return "leve"

        case .moderate: return "moderada"

        case .high: return "grande"

        }
    }
}
