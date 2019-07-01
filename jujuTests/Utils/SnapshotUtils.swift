//
//  SnapshotUtils.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 01/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Nimble
import Nimble_Snapshots
@testable import juju

func matchSnapshot(named name: String,
                   record: Bool = false) -> Predicate<Snapshotable> {
    
    return record ? recordSnapshot(named: name) : haveValidSnapshot(named: name)

}
