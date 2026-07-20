//
//  BookingDetailView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 20/07/26.
//

import SwiftUI
internal import CoreData

struct BookingDetailView: View {
    var booking: Bookings
    var amenity: Amenities?
    var imageIcon:String
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var showCancelAlert = false
    
    private var amenityType: AmenitiesEnum? {
        guard let name = amenity?.name else { return nil }
        return AmenitiesEnum.allCases.first(where: { $0.rawValue.lowercased() == name.lowercased() })
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.blue.opacity(0.15))
                        .frame(height: 200)
                    
                    Image(imageIcon)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    
                    
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(amenity?.name?.uppercased() ?? "AMENITY RESERVATION")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(booking.isExpired ? "Past Booking" : "Confirmed Slot")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(20)
                }
                .padding(.horizontal)
                
                VStack(spacing: 0) {
                    DetailRow(icon: "calendar", title: "Date", value: booking.bookingDate?.toMonthYearString() ?? "N/A")
                    Divider().padding(.leading, 44)
                    DetailRow(icon: "clock", title: "Time Slot", value: booking.timeSlot ?? "N/A")
                    Divider().padding(.leading, 44)
                    DetailRow(
                        icon: "info.circle",
                        title: "Status",
                        value: booking.isExpired ? "Expired" : "Active",
                        valueColor: booking.isExpired ? .secondary : .green
                    )
                }
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.02), radius: 8, x: 0, y: 3)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Important Guidelines")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .padding(.leading, 4)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        GuidelineRow(text: "Please arrive 5 minutes before your schedule.")
                        GuidelineRow(text: "Present the digital check-in proof to the facility supervisor.")
                        if amenityType == .gym {
                            GuidelineRow(text: "Proper athletic shoes and personal towels are required.")
                        } else if amenityType == .pool {
                            GuidelineRow(text: "Shower thoroughly before accessing the pool deck.")
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.02), radius: 8, x: 0, y: 3)
                }
                .padding(.horizontal)
                
                if !booking.isExpired {
                    Button(role: .destructive) {
                        showCancelAlert = true
                    } label: {
                        Text("Cancel Reservation")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.red.opacity(0.08))
                            .foregroundColor(.red)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Booking Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cancel Reservation?", isPresented: $showCancelAlert) {
            Button("Keep Booking", role: .cancel) { }
            Button("Cancel Pass", role: .destructive) {
                booking.isExpired = true
                viewContext.saveData()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to release this time slot reservation? This action cannot be undone.")
        }
    }
}

private struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    var valueColor: Color = .primary
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.blue)
                .frame(width: 28, height: 28)
                .background(Color.blue.opacity(0.08))
                .clipShape(Circle())
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(valueColor)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
    }
}

private struct GuidelineRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.footnote)
                .padding(.top, 2)
            
            Text(text)
                .font(.footnote)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

