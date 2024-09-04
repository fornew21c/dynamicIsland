//
//  DeliveryTrackWidget.swift
//  DeliveryTrackWidget
//
//  Created by Batikan Sosun on 13.08.2022.
//

import ActivityKit
import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.1, *) {
            GroceryDeliveryApp()
        }
    }
}

let remainTime: Date = .now + 120
@available(iOSApplicationExtension 16.1, *)
struct GroceryDeliveryApp: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryActivityAttributes.self) { context in
            LockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    dynamicIslandExpandedLeadingView(context: context)
                }
                DynamicIslandExpandedRegion(.trailing) {
                     dynamicIslandExpandedTrailingView(context: context)
                }
                DynamicIslandExpandedRegion(.center) {
                    dynamicIslandExpandedCenterView(context: context)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    dynamicIslandExpandedBottomView(context: context)
//                    cardDynamicIslandExpandedBottomView(context: context)
                }
              } compactLeading: {
                 compactLeadingView(context: context)
//                  cardCompactLeadingView(context: context)
              } compactTrailing: {
                  compactTrailingView(context: context)
//                  cardCompactTrailingView(context: context)
              } minimal: {
                  minimalView(context: context)
              }
              .keylineTint(Color(hex: 0xf8b73d))
        }
    }
    
    //MARK: Expanded Views
    func dynamicIslandExpandedLeadingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        HStack {
            Spacer().frame(width: 8)
            Image("appicon_40")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .cornerRadius(2)
            
            Text("인천e음배달")
                .font(.system(size:10))
                .bold()
            Spacer()
        }
    }
    
    func dynamicIslandExpandedTrailingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        
        HStack {
            Text(context.state.deliveryStatus)
                .font(.system(size:14))
            Spacer().frame(width: 5)
        }
          
    }
    
    func dynamicIslandExpandedCenterView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {

        HStack {
//            Button(action: {
//                print("button tap in dynamic is")
//            }) {
//                Text("사용 설정")
//                    .font(.system(size: 12))
//              
//            }
//            Text("고객을 향합니다.")
//            Spacer().frame(width: 25)
//            VStack(alignment: .leading) {
//                //            Text(context.state.deliveryStatus)
//                Text("오후 7시 15분 도착 예정")
//                    .font(.system(size:20))
//                    .bold()
//                Spacer().frame(height: 7)
//                Text("우리할매떡볶이 일산식사점")
//                    .font(.system(size:14))
//            }
//            Spacer()
//            Image("imgRiderE56")
//                .resizable()
//                .frame(width: 100, height: 150)
        }
        
    }

    
    func dynamicIslandExpandedBottomView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {       
        
        VStack {
            HStack {
                Spacer().frame(width: 6)
                VStack(alignment: .leading) {
                    Spacer().frame(height: 15)
                   
                    VStack(alignment: .leading) {
                        Text(context.state.arrivalTime)
                            .fixedSize(horizontal: true, vertical: false) // Allow the text to expand horizontally
                            .frame(alignment: .leading)
                            .font(.system(size:22))
                            .bold()
                        Spacer().frame(height: 5)
                        
                        HStack {
                            let url = URL(string: "LiveActivities://?contacNumber=031-336-2345")
                            Link(destination: url!) {
                                HStack {
                                    Text(context.attributes.deliveryMerchantName)
                                        .font(.system(size:14))
                                    Image(systemName: "phone")
                                }
                            }
                        }
                    }
                }
                Spacer()
                HStack(alignment: .top) {
                    Image(context.state.statusImage)
//                    Image("imgRiderE56")
                        .resizable()
                        .frame(width: 80, height: .infinity)
                }
            }
            
            HStack {
                Spacer().frame(width: 6)
                BottomLineView(deliveryBarValue: context.state.deliveryBarValue, shortDeliveryStatus: context.state.shortDeliveryStatus)
                Spacer().frame(width: 6)
                
            }
            Spacer().frame(height: 5)
        }
    
    }
    
    func cardDynamicIslandExpandedLeadingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        VStack {
            HStack {
                Spacer().frame(width: 20)
                Text("QR 결제")
                    .font(.system(size:17))
            }
        }
    }
    
    func cardDynamicIslandExpandedBottomView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        
        HStack {
      
        Spacer().frame(width: 15)
        Image("travelCard")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 75, height: 50)
            .cornerRadius(1.0)

        Spacer().frame(width: 10)
            VStack(alignment: .leading, content: {
                Text("코나카드")
                    .font(.system(size:14))
                    .foregroundColor(.gray)
                   
                Text("트레블 제로카드")
                    .font(.system(size:20))
                    .bold()
            })

         Text(remainTime, style: .timer)
            .font(.system(size: 27))
            .monospacedDigit()
            .multilineTextAlignment(.trailing)
            .foregroundColor(.green)
            .bold()
            
         
        }
    }
    
    
    //MARK: Compact Views
    func compactLeadingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        HStack {
            Spacer()
            Image("appicon_40")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .cornerRadius(2)
        }
    }
    
    func compactTrailingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        Text(context.state.deliveryStatus)
            .font(.system(size:11))
    }
    
    func cardCompactLeadingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        HStack {
            Spacer()
            Image("travelCard")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 20)
                .cornerRadius(1)
        }
    }
    
    func cardCompactTrailingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        return Text(remainTime, style: .timer)
            .multilineTextAlignment(.trailing)
            .frame(width: 50)
            .monospacedDigit()
            .foregroundColor(.green)
            .bold()
    }
    
    func baseballCompactLeadingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        HStack {
            Text("LAD")
                .font(.system(size:14))
                .bold()
            Spacer().frame(width:8)
            Text("7")
                .font(.system(size:14))
                .bold()
            Spacer().frame(width:10)
        }
    }
    
    func baseballCompactTrailingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {

        HStack {
            Text("SF")
                .font(.system(size:14))
                .bold()
            Spacer().frame(width:8)
            Text("5")
                .font(.system(size:14))
                .bold()
            Spacer().frame(width:10)
        }
    }

    func minimalView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        VStack {
            Image("appicon_40")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 12, height: 12)
                .cornerRadius(1)
            Text(context.state.deliveryStatus)
                .font(.system(size:7))

        }
    }
    

    var remainingTimeFormatted: String {
         let minutes = 2 // 2분으로 고정
         let seconds = 0 // 초기 설정이므로 0초
         return String(format: "%02d:%02d", minutes, seconds)
     }
    

}

struct TimerState {
    var remainingTime: TimeInterval
}


extension TimerState {
    var remainingTimeFormatted: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}



@available(iOSApplicationExtension 16.1, *)
struct LockScreenView: View {
    var context: ActivityViewContext<DeliveryActivityAttributes>
    var body: some View {
        VStack {
            HStack {
                LockScreenLeadingView(context: context)
                LockScreenTrailingView(context: context)
            }
            HStack {
                LockScreenBottomView(context: context)
            }
        }
        .padding(15)
        .background(Color(hex: 0x000000))
       
    }
    
    func LockScreenLeadingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        HStack {
            Spacer().frame(width: 6)
            Image("appicon_40")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .cornerRadius(2)
            
            Text("인천e음배달")
                .font(.system(size:10))
                .foregroundColor(.white)
                .bold()
            Spacer()
        }
    }
    
    func LockScreenTrailingView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        
        HStack {
            Text(context.state.deliveryStatus)
                .font(.system(size:14))
                .foregroundColor(.white)
            Spacer().frame(width: 5)
        }
    }
    
    func LockScreenBottomView(context: ActivityViewContext<DeliveryActivityAttributes>) -> some View {
        
        VStack {
            HStack {
                Spacer().frame(width: 6)
                VStack(alignment: .leading) {
                    Spacer().frame(height: 15)
                   
                    VStack(alignment: .leading) {
                        Text(context.state.arrivalTime)
                            .fixedSize(horizontal: true, vertical: false) // Allow the text to expand horizontally
                            .frame(alignment: .leading)
                            .font(.system(size:22))
                            .foregroundColor(.white)
                            .bold()
                        Spacer().frame(height: 5)
                        
                        Text(context.attributes.deliveryMerchantName)
                            .font(.system(size:13))
                            .foregroundColor(.white)
                        Spacer()
                        
                    }
                }
                Spacer()
                HStack(alignment: .top) {
                    Image(context.state.statusImage)
                        .resizable()
                        .frame(width: 80, height: .infinity)
                }
            }
            
            HStack {
                Spacer().frame(width: 6)
                BottomLineViewFromLockScreen(deliveryBarValue: context.state.deliveryBarValue, shortDeliveryStatus: context.state.shortDeliveryStatus)
                Spacer().frame(width: 6)
                
            }
            Spacer().frame(height: 5)
        }
    
    }
}

struct BottomLineView: View {
    var deliveryBarValue: Float
    var shortDeliveryStatus: String
    var body: some View {
        HStack {
            VStack {
                Gauge(value: deliveryBarValue, in: 0...100) {
                } currentValueLabel: {
                    HStack(alignment: .center) {
                    }
                }
            }
        }
    }
}

struct BottomLineViewFromLockScreen: View {
    var deliveryBarValue: Float
    var shortDeliveryStatus: String
    var body: some View {
        HStack {
            VStack {
                Gauge(value: deliveryBarValue, in: 0...100) {
                } currentValueLabel: {
                    HStack(alignment: .center) {
                    }
                }
            }
        }
        .background(Color(hex: 0x424242))
        .cornerRadius(12)
    }
     
}


struct BottomLineView2: View {
    @State private var status = 10.0
   
    var deliveryBarValue: Float
    var shortDeliveryStatus: String
    var body: some View {
        HStack {
//            Divider().frame(width: 50,
//                            height: 10)
//            .overlay(.gray).cornerRadius(5)
            Image("imgRiderE56")
            VStack {
//                RoundedRectangle(cornerRadius: 5)
//                    .stroke(style: StrokeStyle(lineWidth: 1,
//                                               dash: [4]))
//                    .frame(height: 10)
//                    .overlay(Text(time, style: .timer).font(.system(size: 8)).multilineTextAlignment(.center))
                Gauge(value: deliveryBarValue, in: 0...100) {
//                    Image("imgRiderE56")
//                        .frame(width: 50.0, height: 50.0)
                } currentValueLabel: {
                    HStack(alignment: .center) {
                       
                        Text(shortDeliveryStatus)
//                        Text(time, style: .timer).font(.system(size: 12)).multilineTextAlignment(.center)
//                        Text(time).font(.system(size: 12)).multilineTextAlignment(.center)
                    }
                    
                }
//                .overlay(Text(time, style: .timer).font(.system(size: 8)).multilineTextAlignment(.center))
            }
            Image("home-address")
        }
    }
}


extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
