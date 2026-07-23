import SwiftUI
import CoreData

struct BookingView: View {

    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var viewModel: BookingViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                Picker("Filter Bookings", selection: $viewModel.selectedFilter) {
                    Text("Upcoming").tag(0)
                    Text("Past History").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                .background(Color(.systemBackground))

                if viewModel.filteredBookings.isEmpty {
                    ContentUnavailableView {
                        Label(
                            viewModel.selectedFilter == 0 ? "No Upcoming Bookings" : "No Past History",
                            systemImage: "calendar.badge.clock"
                        )
                    } description: {
                        Text(viewModel.selectedFilter == 0 ? "Any new reservations you make will appear right here." : "Your completed booking history will be saved here.")
                    }
                    .background(Color(.systemGroupedBackground))
                } else {
                    List {
                        ForEach(viewModel.filteredBookings) { item in
                            BookingRowItemView(
                                booking: item,
                                viewModel: viewModel,
                                lookTap: {
                                    viewModel.selectedBooking = item
                                })
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Bookings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title3)
                    }
                }
            }
            .sheet(item: $viewModel.selectedBooking) { targetBooking in
                let type = viewModel.amenityType(for: targetBooking)

                BookingDetailView(
                    booking: targetBooking,
                    amenity: viewModel.matchedAmenity(for: targetBooking),
                    imageIcon: type?.image(for: type ?? .pool) ?? ""
                )
            }
        }
    }
}

struct BookingRowItemView: View {
    let booking: Bookings
    @ObservedObject var viewModel: BookingViewModel

    var lookTap: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 2)
                .fill(booking.isExpired ? Color.gray.opacity(0.4) : Color.blue)
                .frame(width: 4, height: 44)

            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(booking.isExpired ? Color(.secondarySystemBackground) : Color.blue.opacity(0.08))
                    .frame(width: 48, height: 48)

                Image(systemName: booking.isExpired ? "calendar" : viewModel.amenityIcon(for: booking))
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(booking.isExpired ? .secondary : .blue)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.resolvedAmenityName(for: booking).capitalized)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(booking.isExpired ? .secondary : .primary)

                HStack(spacing: 12) {
                    Label(booking.bookingDate?.toMonthYearString() ?? "N/A", systemImage: "calendar")
                    Label(booking.timeSlot ?? "N/A", systemImage: "clock")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            if booking.isExpired {
                Text("Expired")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.secondarySystemBackground))
                    .foregroundColor(.secondary)
                    .clipShape(Capsule())
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.tertiaryLabel))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 3)
        .contentShape(Rectangle())
        .onTapGesture {
            lookTap()
        }
    }
}
