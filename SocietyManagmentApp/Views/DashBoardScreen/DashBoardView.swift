//
//  DashBoardView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 15/07/26.
//

import SwiftUI
import CoreData

struct DashBoardView: View {
    @Binding var selectedTabView: Int

    @Environment(DashboardViewModel.self) var viewModel: DashboardViewModel
    @Environment(MaintenanceViewModel.self) var maintenanceVM: MaintenanceViewModel
    @Environment(VisitorViewModel.self) var visitorVM: VisitorViewModel
    @Environment(NoticesViewModel.self) var noticesVM: NoticesViewModel
    @Environment(AmenitiesViewModel.self) var amenitiesVM: AmenitiesViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                if let profile = viewModel.profile {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("GreenValley")
                                .font(.title)
                                .bold()
                            Text("\(viewModel.greeting) \(profile.name ?? "N/A") 👋")
                        }.padding()
                        Spacer()
                    }

                    WelcomeCardView(userName: profile.name ?? "N/A")
                        .padding(.horizontal)

                    MaintenanceRowView(selectedTabView: $selectedTabView)

                    AmenitiesColumnView(profile: profile)

                    NoticeEventsRowView(profile: profile)

                    Spacer()
                }
            }
            .padding(.all, 5)
        }
    }
}
