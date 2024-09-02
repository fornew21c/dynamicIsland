
import SwiftUI
import ActivityKit

@available(iOS 16.1, *)
struct ContentView: View {
    @State var  activities = Activity<DeliveryActivityAttributes>.activities
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Create an activity to start a live activity")
                    Button(action: {
                        createActivity()
                        listAllDeliveries()
                    }) {
                        Text("주문 접수").font(.headline)
                            .foregroundColor(.blue)
                    }
                    Button(action: {
                        createActivity()
                        listAllDeliveries()
                    }) {
                        Text("코나QR결제").font(.headline)
                            .foregroundColor(.blue)
                    }
                    Button(action: {
                        endAllActivity()
                        listAllDeliveries()
                    }) {
                        Text("모든 배달 종료").font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                Section {
                    if !activities.isEmpty {
                        Text("진행 중 배달")
                    }
                    activitiesView()
                }
            }
            .navigationTitle("배달 관리!")
            .fontWeight(.ultraLight)
        }
        
    }
    
    func createActivity() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if error != nil {
                // Handle the error here.
            }
            
            // Enable or disable features based on the authorization.
        }
        
        let randomOrderNo = Int.random(in: 1..<100000)
       
        
        let date = Date()
        let arrivalTime = Calendar.current.date(byAdding: .minute, value: 30, to: date)
        
        guard let arrivalTime = arrivalTime else { return }
        
        let contentState = DeliveryActivityAttributes.LiveDeliveryData(deliveryStatus: "조리중",
                                                                         deliveryBarValue: 33,
                                                                         shortDeliveryStatus: "조리중",
                                                                         statusImage: "cooking",
                                                                         arrivalTime: arrivalTimeToString(arrivalTime: arrivalTime))
        
        let attributes = DeliveryActivityAttributes(orderNumber: randomOrderNo,
                                                      fixedArrivalTime: arrivalTimeToString(arrivalTime: arrivalTime),
                                                      deliveryMerchantName: "우리할매떡볶이 인천서구점")
        do {
            let activity = try Activity<DeliveryActivityAttributes>.request(
                attributes: attributes,
                contentState: contentState,
                pushType: PushType.token)
            
            print("Activity Added Successfully. id: \(activity.id)")
            Task {
                 for await data in activity.pushTokenUpdates {
                    let myToken = data.map {String(format: "%02x", $0)}.joined()
                    // Keep this myToken for sending push notifications
                     print("act push token: \(myToken)")
                 }
              }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func update(activity: Activity<DeliveryActivityAttributes>) {
        
        Task {
            let updatedStatus = DeliveryActivityAttributes.LiveDeliveryData(deliveryStatus: activity.contentState.deliveryStatus,
                                                                              deliveryBarValue: activity.contentState.deliveryBarValue,
                                                                              shortDeliveryStatus: activity.contentState.deliveryStatus,
                                                                              statusImage: activity.contentState.statusImage,
                                                                              arrivalTime: activity.contentState.arrivalTime)
            let alertConfiguration = AlertConfiguration(title: "Delivery update", body: "Your pizza order will arrive in 25 minutes.", sound: .default)
            await activity.update(using: updatedStatus, alertConfiguration: alertConfiguration)
        }
    }

    func ridingNow(activity: Activity<DeliveryActivityAttributes>) {
        Task {
            let updatedStatus = DeliveryActivityAttributes.LiveDeliveryData(deliveryStatus: "배달시작",
                                                                              deliveryBarValue: 50,
                                                                              shortDeliveryStatus: "배달시작",
                                                                              statusImage: "delivering",
                                                                              arrivalTime: activity.contentState.arrivalTime)
            await activity.update(using: updatedStatus)
        }
    }
    
    func deliveryDone(activity: Activity<DeliveryActivityAttributes>) {
        Task {
            let updatedStatus = DeliveryActivityAttributes.LiveDeliveryData(deliveryStatus: activity.contentState.deliveryStatus,
                                                                              deliveryBarValue: activity.contentState.deliveryBarValue,
                                                                              shortDeliveryStatus: "픽업완료",
                                                                              statusImage: activity.contentState.statusImage,
                                                                              arrivalTime: activity.contentState.arrivalTime)
            
            await activity.update(using: updatedStatus)
        }
    }
    
    func end(activity: Activity<DeliveryActivityAttributes>) {
        Task {
            await activity.end(dismissalPolicy: .immediate)
        }
    }
    func endAllActivity() {
        Task {
            for activity in Activity<DeliveryActivityAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
    func listAllDeliveries() {
        var activities = Activity<DeliveryActivityAttributes>.activities
        activities.sort { $0.id > $1.id }
        self.activities = activities
    }
    
    func updateFromView(activity: Activity<DeliveryActivityAttributes>) {
        
        Task {
            let updatedStatus = DeliveryActivityAttributes.LiveDeliveryData(deliveryStatus: "배달시작",
                                                                              deliveryBarValue: 66,
                                                                              shortDeliveryStatus: "배달시작",
                                                                              statusImage: "delivering",
                                                                              arrivalTime: activity.attributes.fixedArrivalTime)
            let alertConfiguration = AlertConfiguration(title: "Delivery update", body: "Your pizza order will arrive in 25 minutes.", sound: .default)
            await activity.update(using: updatedStatus, alertConfiguration: alertConfiguration)
        }
    }
    
    func deliveryDoneFromView(activity: Activity<DeliveryActivityAttributes>) {
        Task {
            let updatedStatus = DeliveryActivityAttributes.LiveDeliveryData(deliveryStatus: "배달완료",
                                                                              deliveryBarValue: 100,
                                                                              shortDeliveryStatus: "배달완료",
                                                                              statusImage: "delivering",
                                                                              arrivalTime: "맛있게 드세요 :)")
            let alertConfiguration = AlertConfiguration(title: "Delivery update", body: "Your pizza order will arrive in 25 minutes.", sound: .default)
            await activity.update(using: updatedStatus, alertConfiguration: alertConfiguration)
        }
    }
    
    func arrivalTimeToString(arrivalTime: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시 mm분" // 2020-08-13 16:30
        dateFormatter.locale = Locale(identifier:"ko_KR")
        let arrivalTimeStr = dateFormatter.string(from: arrivalTime ) + " 도착 예정"
        
        return arrivalTimeStr
    }
}


@available(iOS 16.1, *)
extension ContentView {
    
    func activitiesView() -> some View {
        var body: some View {
            ScrollView {
                ForEach(activities, id: \.id) { activity in
//                    let courierName = activity.orderNumber
                    let orderNumber = String(activity.attributes.orderNumber)
//                    let deliveryTime = activity.contentState.deliveryTime
                    HStack(alignment: .center) {
                        Text("주문번호: " + orderNumber)
                        //Text(deliveryTime, style: .timer)
                        Text("pickup")
                            .font(.headline)
                            .foregroundColor(.green)
                            .onTapGesture {
                                updateFromView(activity: activity)
                                listAllDeliveries()
                            }
                        Text("riding")
                            .font(.headline)
                            .foregroundColor(.green)
                            .onTapGesture {
                                ridingNow(activity: activity)
                                listAllDeliveries()
                            }
                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.green)
                            .onTapGesture {
                                deliveryDoneFromView(activity: activity)
                                listAllDeliveries()
                            }
                        Text("end")
                            .font(.headline)
                            .foregroundColor(.green)
                            .onTapGesture {
                                end(activity: activity)
                                listAllDeliveries()
                            }
                    }
                }
            }
        }
        return body
    }
}
