import SwiftUI
import CoreData

struct AddVisitorView: View {

    @State var name: String = ""
    @State var phone: String = ""
    @State var purpose: String = ""
    @State var vehicleNo: String = ""
    @State var flatNo: String = ""
    @State var inside: Bool = false
    @State var address: String = ""
    @State var arrival_time: Date = Date()

    @Environment(VisitorViewModel.self) var viewModel: VisitorViewModel

    var body: some View {
        VStack {
            VisitorHeaderView(name: $name, phone: $phone, purpose: $purpose, vehicleNo: $vehicleNo, flatNo: $flatNo, inside: $inside, address: $address, arrival_time: $arrival_time, viewModel: viewModel)

            AddVisitorScrollView(name: $name, phone: $phone, purpose: $purpose, vehicleNo: $vehicleNo, flatNo: $flatNo, inside: $inside, address: $address, arrival_time: $arrival_time)

            Spacer()
        }
    }
}

struct AddVisitorScrollView: View {

    @Binding var name: String
    @Binding var phone: String
    @Binding var purpose: String
    @Binding var vehicleNo: String
    @Binding var flatNo: String
    @Binding var inside: Bool
    @Binding var address: String
    @Binding var arrival_time: Date

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Visitor Details")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                HStack(spacing: 14) {
                    Image(systemName: inside ? "door.left.hand.open" : "door.left.hand.closed")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(inside ? .green : .gray)
                        .frame(width: 24)

                    Toggle("Currently Inside", isOn: $inside)
                        .font(.body)
                        .tint(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.primary.opacity(0.05)))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                .padding(.horizontal)

                AddVisitorCustomFieldView(name: $name, image: "person.fill", placeHolder: "Name")
                AddVisitorCustomFieldView(name: $phone, image: "phone.fill", placeHolder: "Phone")
                AddVisitorCustomFieldView(name: $purpose, image: "info.circle.fill", placeHolder: "Purpose")
                AddVisitorCustomFieldView(name: $vehicleNo, image: "car.fill", placeHolder: "Vehicle Number")
                AddVisitorCustomFieldView(name: $flatNo, image: "building.2.fill", placeHolder: "Flat Number")
                AddVisitorCustomFieldView(name: $address, image: "house.fill", placeHolder: "Address")

                HStack(spacing: 14) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(width: 24)

                    DatePicker("Arrival Time", selection: $arrival_time, in: Date()..., displayedComponents: [.hourAndMinute, .date])
                        .font(.body)
                        .labelsHidden()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.primary.opacity(0.05)))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                .padding(.horizontal)

            }
            .padding(.top)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct AddVisitorCustomFieldView: View {
    @Binding var name: String
    var image: String
    var placeHolder: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: image)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
                .frame(width: 24)

            TextField(placeHolder, text: $name)
                .font(.body)
                .autocorrectionDisabled()
                .tint(.blue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.primary.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        .padding(.horizontal)
    }
}

struct VisitorHeaderView: View {

    @Environment(\.dismiss) var dismiss

    @Binding var name: String
    @Binding var phone: String
    @Binding var purpose: String
    @Binding var vehicleNo: String
    @Binding var flatNo: String
    @Binding var inside: Bool
    @Binding var address: String
    @Binding var arrival_time: Date

    var viewModel: VisitorViewModel

    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Text("Cancel")
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            .background(.blue)
            .clipShape(Capsule())

            Spacer()

            Text("Add Visitor")
                .font(.title)
                .bold()

            Spacer()

            Button(action: {
                viewModel.addVisitor(
                    name: name,
                    phone: phone,
                    purpose: purpose,
                    vehicleNo: vehicleNo,
                    flatNo: flatNo,
                    inside: inside,
                    address: address,
                    arrivalTime: arrival_time
                )
                dismiss()
            }) {
                Text("Add")
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            .background(.blue)
            .clipShape(Capsule())

        }.padding()
    }
}

#Preview {
    AddVisitorView()
}
