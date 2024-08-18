
import SwiftUI
import ActivityKit

struct DeliveryActivityAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState

    public var orderNumber: Int
    public var fixedArrivalTime: String
    public var deliveryMerchantName: String
    public struct ContentState: Codable, Hashable {
        var deliveryStatus: String
        var deliveryBarValue: Float
        var shortDeliveryStatus: String
        var statusImage: String
        var arrivalTime: String
    }
    var id = UUID()
}



