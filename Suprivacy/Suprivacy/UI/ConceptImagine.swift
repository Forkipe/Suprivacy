import SwiftUI
import Foundation
import Lottie

struct ConceptImagine: View {
    @State var notionPageId = "1574c923ea368098a8b6ce7685d8e541"
    @State var theme = ""
    @State var responseConcept = ""
    @State var generated = false
    @State var generating = false
    @State var notionContent = ""
    @State var showAlert:Bool = false
    @State private var alertMessage = ""
    var body: some View {
        ZStack {
            LottieView(animation: .named("Animation - 1734730219117"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            VStack {
                ElementsUI().title("TEST FUNCTIONALITY⚠️")
                Spacer()
            }
            if !generated && !generating {
                preGeneratedUI
                
            } else if generating && !generated {
                LottieView(animation: .named("Animation - 1734730564918"))
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .aspectRatio(contentMode: .fill)
                
            } else {
                generatedUI
            }
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            readNotionPage()
        }
    }
    private var preGeneratedUI: some View {
        VStack {
            ElementsUI().title("Concepts")
            
            ElementsUI().customTextField("Enter your theme", text: $theme)
            
            ElementsUI().customButton("Generate", width: 200, action: {
                
                if !theme.isEmpty && !theme.starts(with: " ") {
                    generating = true
                    let requestBody:[String:Any] = ["prompt": "Generate a concept featuring \(theme) theme, here are a few concepts you can take inspiration from: \(notionContent). You can take those examples combine them to create a new one, but remember to keep it simple and \(theme) themed. Answer in english language. Write just the concept and nothing else"]
                    makeAPICall(with: requestBody) {response in
                        responseConcept = response
                        generated = true
                        generating = false
                    }
                } else {
                    print("hi")
                    showAlert(message: "Enter theme!")
                }
            }).disabled(notionContent.isEmpty)
        }
        .frame(width: 500, height: 450)
    }
    private var generatedUI: some View {
        VStack {
            ScrollView {
                Text(responseConcept).padding(.horizontal, 20)
            }
        }.frame(width: 500, height: 450)
    }
    
    func makeAPICall(with requestBody: [String: Any], completion: @escaping (String) -> Void) {
       
        let accountID = ApiKeys.cloudflareID
        let apiToken = ApiKeys.cloudflareKey
        let urlString = "https://api.cloudflare.com/client/v4/accounts/\(accountID)/ai/run/@cf/meta/llama-3.1-8b-instruct"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Failed to encode request body: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server returned an error")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = jsonResponse["result"] as? [String: Any],
                   let response = result["response"] as? String {
                    completion(response)
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }
        
        task.resume()
    }
    func readNotionPage() {
        print("START")
        let token = ApiKeys.notionKey
        let urlString = "https://api.notion.com/v1/blocks/\(notionPageId)/children"

        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2022-06-28", forHTTPHeaderField: "Notion-Version") // Ensure correct API version
        print("Request prepared. URL: \(url)")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                print("Response received, attempting to decode...")
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = jsonResponse["results"] as? [[String: Any]] {
                    print("Results decoded, extracting text...")

                    let textContent = results.compactMap { block in
                        // Check for the block type
                        if let type = block["type"] as? String,
                           let typeContent = block[type] as? [String: Any] {
                            // Extract rich text
                            if let richText = typeContent["rich_text"] as? [[String: Any]] {
                                return richText.compactMap { textItem in
                                    textItem["plain_text"] as? String
                                }.joined(separator: "")
                            }
                        }
                        return nil
                    }.joined(separator: "\n")

                    DispatchQueue.main.async {
                        print("Text content extracted successfully.")
                        self.notionContent = textContent
                        print("Extracted Text Content: \(textContent)")
                    }
                } else {
                    print("Failed to parse JSON response.")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw JSON: \(jsonString)")
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        task.resume()
    }
    private func showAlert(message: String) {
        DispatchQueue.main.async {
            alertMessage = message
            showAlert = true
        }
    }
}

