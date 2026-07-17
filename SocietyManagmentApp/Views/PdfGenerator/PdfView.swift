//
//  PdfView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI

struct PdfView: View {
    @ObservedObject var maintenance:Maintenance
    @ObservedObject var profile:Profile
    
    var body: some View {
        VStack{
            Text("Recipt")
            VStack{
                PdfTextView(text: "ReciptNo", value: maintenance.receiptNo ?? "N/A")
                Divider()
                PdfTextView(text: "Username", value: profile.name ?? "N/A")
                Divider()
                PdfTextView(text: "Flat_no", value: profile.flat_no ?? "N/A")
                Divider()
                PdfTextView(text: "PaymentDate", value: maintenance.paymentDate?.toMonthYearString() ?? "N/A")
                Divider()
                PdfTextView(text: "TransactionID", value: maintenance.transactionId?.uuidString ?? "N/A")
                Divider()
                PdfTextView(text: "Status", value: maintenance.status ?? "N/A")
            }
            .background(.gray.opacity(0.2),in: RoundedRectangle(cornerRadius: 10))
            
            Spacer()
        }
        .padding()
    }
}

struct PdfTextView:View{
    var text:String
    var value:String
    var body: some View{
        HStack{
            Text("\(text):")
            Spacer()
            Text(value)
        }
        .padding()
    }
}

//#Preview {
//    PdfView()
//}
