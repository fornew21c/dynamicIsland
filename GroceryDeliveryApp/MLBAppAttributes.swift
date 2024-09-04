//
//  MLBAppAttributes.swift
//  GroceryDeliveryApp
//
//  Created by 허원철(Woncheol Heo) on 9/3/24.
//

import SwiftUI
import ActivityKit


struct MLBActivityAttributes: ActivityAttributes, Identifiable {
    public typealias LiveMLBData = ContentState
   
    public struct ContentState: Codable, Hashable {
        var awayTeam: String
        var homeTeam: String
        var pitcher: String
        var hitter: String
        var ERA: Float
        var battingAverage: Float
        var live: String
    }
    var id = UUID()
}

