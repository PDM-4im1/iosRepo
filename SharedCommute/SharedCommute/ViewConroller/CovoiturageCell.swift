import SwiftUI

struct CovoiturageCell: View {
    let conducteur: Conducteur
    let user: User
    let moyenDeTransport: MoyenDeTransport

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 4)
                    Text(user.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                }

                HStack {
                    Image(systemName: "phone")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 4)
                    Text("\(user.phoneNumber)")
                        .foregroundColor(Color.gray)
                }

                HStack {
                    Image(systemName: "car")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 4)
                    Text("\(moyenDeTransport.marque) \(moyenDeTransport.type)")
                        .foregroundColor(Color.gray)
                }
            }
            Spacer()
            Image("driver_avatar")
                .resizable()
                .frame(width: 48, height: 48)
                .clipShape(Circle())

        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
        .padding(.horizontal, 15)
        .padding(.bottom, 12)
    }
}
