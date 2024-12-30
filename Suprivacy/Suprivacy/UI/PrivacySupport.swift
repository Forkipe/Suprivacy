import Foundation
import SwiftUI
import AVFoundation
import Lottie
import ConfigCat

struct PrivacySupport:View {
    private let templatesPrivacy: [String: String] = TemplatesPrivacy().templates
    private let templatesSupport: [String: String] = TemplatesSupport().templates
    @State private var types = ["Policy", "Support"]
    @State var selectedType: String = "Policy"
    @State private var selectedTemplatePolicy = "Template Privacy 1"
    @State private var selectedTemplateSupport = "Template Support 1"
    @State private var appName = ""
    @State private var link = ""
    @State private var mail = ""
    @State private var fileName = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showImage = false
    @State private var gcd = false
    @State private var hueRotation = 0.0
    private var player: AVAudioPlayer?
    var body: some View {
        ZStack {
            LottieView(animation: .named("Animation - 1734730219117"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("v1.0.2")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            VStack(spacing: 30) {
                Picker("", selection: $selectedType) {
                    ForEach(types, id: \.self) { templateName in
                        Text(templateName)
                    }
                }
                .frame(width: 300)
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .shadow(radius: 5)
                
                if selectedType == "Policy" {
                    policyView
                } else {
                    supportView
                }
            }
            .padding()
            .onAppear {
                Task {
                    await getValue()
                    if !gcd {
                        types = ["Support"]
                        selectedType = "Support"
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
           
        }
    }

    // MARK: - Policy View
    private var policyView: some View {
        VStack(spacing: 20) {
            ElementsUI().title("Policy Template Customizer")
            
            ElementsUI().customPicker("Select Template", selection: $selectedTemplatePolicy, items: templatesPrivacy.keys.sorted(by: { extractNumeric($0) < extractNumeric($1) }))
            
            ElementsUI().customTextField("Enter App Name", text: $appName)
            ElementsUI().customTextField("Enter link", text: $link)
            ElementsUI().customTextField("Enter dev mail", text: $mail)
            ElementsUI().customTextField("Enter file name", text: $fileName)
            
            
            ZStack {
                
                ElementsUI().customButton("Save HTML", width: 150) {
                    savePrivacy()
                }
                
            }
        }
        .frame(width: 500, height: 450)
        .background {
            LottieView(animation: .named("Animation - 1734730296826"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .aspectRatio(contentMode: .fit)
                .padding(.leading, 50)
                .padding(.trailing, 50)
            
        }
    }

    // MARK: - Support View
    private var supportView: some View {
        VStack(spacing: 35) {
            ElementsUI().title("Support Template Customizer")
            ElementsUI().customPicker("Select Template", selection: $selectedTemplateSupport, items: templatesSupport.keys.sorted(by: { extractNumeric($0) < extractNumeric($1) }))
            
            ElementsUI().customTextField("Enter App Name", text: $appName)
            ElementsUI().customTextField("Enter dev mail", text: $mail)
            ElementsUI().customTextField("Enter file name", text: $fileName)
            ZStack {
                
                ElementsUI().customButton("Save HTML", width: 150) {
                    saveSupport()
                    
                }
            }
        }
        .frame(width: 500, height: 450)
        .background {
            LottieView(animation: .named("Animation - 1734730296826"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .aspectRatio(contentMode: .fit)
                .padding(.leading, 50)
                .padding(.trailing, 50)
        }
    }
    
    private func savePrivacy() {
           guard let template = templatesPrivacy[selectedTemplatePolicy] else {
               showAlert(message: "Template not found.")
               return
           }

           guard !appName.isEmpty, !mail.isEmpty, !link.isEmpty else {
               showAlert(message: "All fields are required.")
               return
           }

           let customizedHTML = customizeTemplate(template, with: ["appName": appName, "link": link, "mail": mail])
           
        let panel = NSSavePanel()
           panel.title = "Save HTML"
        panel.allowedContentTypes = [.html]
           panel.nameFieldStringValue = "\(fileName).html"
           
           panel.begin { response in
               if response == .OK, let fileURL = panel.url {
                   do {
                       try customizedHTML.write(to: fileURL, atomically: true, encoding: .utf8)
                       showAlert(message: "HTML file saved successfully at \(fileURL.path).")
                       //showPopUpImage()
                   } catch {
                       showAlert(message: "Failed to save HTML file: \(error.localizedDescription)")
                   }
               }
           }
       }
       
       private func saveSupport() {
           guard let template = templatesSupport[selectedTemplateSupport] else {
               showAlert(message: "Template not found.")
               return
           }

           guard !appName.isEmpty, !mail.isEmpty else {
               showAlert(message: "All fields are required.")
               return
           }

           let customizedHTML = customizeTemplate(template, with: ["appName": appName, "mail": mail])
           
           let panel = NSSavePanel()
              panel.title = "Save HTML"
           panel.allowedContentTypes = [.html]
              panel.nameFieldStringValue = "\(fileName).html"
              
              panel.begin { response in
                  if response == .OK, let fileURL = panel.url {
                      do {
                          try customizedHTML.write(to: fileURL, atomically: true, encoding: .utf8)
                          showAlert(message: "HTML file saved successfully at \(fileURL.path).")
                          
                      } catch {
                          showAlert(message: "Failed to save HTML file: \(error.localizedDescription)")
                      }
                  }
              }
          }

       
       
       private func customizeTemplate(_ template: String, with data: [String: String]) -> String {
           var result = template
           for (key, value) in data {
               result = result.replacingOccurrences(of: "{{\(key)}}", with: value)
           }
           return result
       }

       private func showAlert(message: String) {
           DispatchQueue.main.async {
               alertMessage = message
               showAlert = true
           }
       }

    
    private func extractNumeric(_ string: String) -> Int {
        let number = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Int(number) ?? 0
    }
    func getValue() async {
        let client = ConfigCatClient.get(sdkKey: "configcat-sdk-1/IKrbCJthQkiPxAJEE8GwnQ/YWplfBV2NUuVQDWdn848Qw") { options in  // <-- This is the actual SDK Key for your 'Test Environment' environment.
           options.logLevel = .info // Set the log level to INFO to track how your feature flags were evaluated. When moving to production, you can remove this line to avoid too detailed logging.
        }
         gcd = await client.getValue(for: "GCD", defaultValue: false)
    }
}

