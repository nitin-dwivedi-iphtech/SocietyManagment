//
//  WelcomeCardView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI


struct WelcomeCardView: View {

    var date:Date = Date()
    var userName:String
    var maintenance:FetchedResults<Maintenance>
    var visitors:FetchedResults<Visitor>
    
    var computedMaintenance:Int {
        maintenance.filter{ !$0.isPaid }.reduce(0) { $0 + Int($1.amount) }
    }
    
    var body: some View {
        VStack(alignment:.leading,spacing:11){
            Text(date,style:.date)
                .bold()
                .foregroundColor(.white.opacity(0.7))
            
            Text("Good Morning,")
                .font(.system(size: 25))
                .foregroundColor(.white)
                .bold()
            
            Text("\(userName) 👋")
                .foregroundColor(.blue)
                .bold()
                .font(.system(size: 20))
            
            HStack(spacing: 10) {
                BadgeView(value: "\(visitors.filter{ $0.inside }.count)", label: "Inside", icon: "checkmark.circle.fill", color: .green)
                BadgeView(value: "3", label: "Open", icon: "envelope.open.fill", color: .blue)
                BadgeView(value: "\(computedMaintenance)", label: "Due", icon: "exclamationmark.triangle.fill", color: .orange)
            }
        }
        .padding(.horizontal,20)
        .padding(.vertical)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: [Color.grandBlack, Color.grandBlue], startPoint: .topTrailing, endPoint: .bottomLeading),
                        in: RoundedRectangle(cornerRadius: 10))
    }
}


struct BadgeView:View{
    let value: String
    let label: String
    let icon: String
    let color: Color
    var body: some View{
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
            
            Text(value)
                .font(.system(size:10, design: .rounded))
                .fontWeight(.bold)
            
            Text(label)
                .font(.footnote)
                .fontWeight(.medium)
        }
        .foregroundColor(color)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
    }
    
}

//#Preview {
//    WelcomeCardView(userName: "Nitin")
//}
