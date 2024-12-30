import Foundation
import SwiftUI
import Lottie

class ElementsUI {
    @ViewBuilder
    func title(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .foregroundColor(.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
            .shadow(radius: 5)
    }

    @ViewBuilder
    func customPicker(_ title: String, selection: Binding<String>, items: [String]) -> some View {
        Picker(title, selection: selection) {
            ForEach(items, id: \.self) { templateName in
                Text(templateName)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
        .shadow(radius: 5)
    }

    @ViewBuilder
    func customTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            .shadow(radius: 5)
            .foregroundColor(.white)
    }

    @ViewBuilder
    func customButton(_ title: String, width:CGFloat ,action: @escaping () -> Void) -> some View {
        Button(action: action) {
                Text(title)
                    .bold()
                    .frame(width: width)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    
        }.buttonStyle(PlainButtonStyle())
    }
}
