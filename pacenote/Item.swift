//
//  Item.swift
//  pacenote
//
//  Created by Kai Yang on 2026/7/7.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
