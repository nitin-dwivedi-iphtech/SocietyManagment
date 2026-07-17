//
//  ProfileView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profile: Profile
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                HStack {
                    ProfileHeaderView(profile: profile)
                    Spacer()
                }
                .padding(.top, 8)
                
                ProfileCardView(profile: profile)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Resident Details")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                    
                    VStack(spacing: 0) {
                        ProfileDetailRow(
                            icon: "house.fill",
                            label: "Flat No.",
                            value: (profile.flat_no as String?) ?? "N/A"
                        )
                        Divider().padding(.leading, 44)
                        
                        ProfileDetailRow(
                            icon: "person.2.fill",
                            label: "Family Members",
                            value: "\(profile.family_members)"
                        )
                        Divider().padding(.leading, 44)
                        
                        ProfileDetailRow(
                            icon: "calendar",
                            label: "Date of Birth",
                            value: (profile.dob as Date?)?.formatted(date: .long, time: .omitted) ?? "Not Added"
                        )
                    }
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Contact Information")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                    
                    VStack(spacing: 0) {
                        ProfilePhoneRow(
                            icon: "phone.fill",
                            label: "Phone",
                            phoneNumber: profile.phone as String?
                        )
                        
                        Divider().padding(.leading, 44)
                        
                        ProfilePhoneRow(
                            icon: "exclamationmark.bubble.fill",
                            label: "Emergency Contact",
                            phoneNumber: profile.emergency_no as String?
                        )
                    }
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                }
                
                Spacer()
            }
            .padding()
        }
    }
}



struct ProfileDetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 30, height: 30)
                .background(Color.green.opacity(0.1), in: Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }
            Spacer()
        }
        .padding()
    }
}

struct ProfilePhoneRow: View {
    let icon: String
    let label: String
    let phoneNumber: String?
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 30, height: 30)
                .background(Color.green.opacity(0.1), in: Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(phoneNumber ?? "Not Added")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(phoneNumber != nil ? .primary : .secondary)
            }
            
            Spacer()
            
            Button(action: {
                if let url = URL(string: "tel://\(phoneNumber ?? "")"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }) {
                Image(systemName: "phone.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.green)
            }
            .buttonStyle(.borderless)
            
        }
        .padding()
    }
    
}


