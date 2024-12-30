
import Foundation
import SwiftUI
import Lottie

struct DescriptionIcon: View {
    @State var promt = ""
    @State var appName = ""
    @State var generated = false
    @State var generating = false
    @State var description: String = ""
    @State private var parsedAppName: String = ""
    @State private var parsedSubtitle: String = ""
    @State private var parsedDescription: String = ""
    @State private var parsedKeys: String = ""
    @State private var notionPageId: String = "1574c923ea3680358e40f6230e859d2f"
    @State private var selectedImage:String = ""
    @State private var imageChosen:Bool = false
    @State private var firstTime:Bool = true
    @State var showAlert:Bool = false
    @State private var alertMessage = ""
    var body: some View {
        ZStack {
            LottieView(animation: .named("Animation - 1734730219117"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            if generated || !generating {
                LottieView(animation: .named("DescriptionBg"))
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
            }
            
            if !generated && !generating {
                preGenerateUI
                    
            } else if !generated && generating {
                LottieView(animation: .named("Animation - 1734730564918"))
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .aspectRatio(contentMode: .fill)
            } else {
                resultUI
                    
            }
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .animation(.easeInOut, value: generated || generating)
    }

    // MARK: - Pre-Generate UI
    private var preGenerateUI: some View {
        VStack(spacing: 30) {
            ElementsUI().title("Enter app concept description")
                .padding(.top, 20)
            Spacer()
            TextEditor(text: $promt)
                .frame(width: 350, height: 200)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.2)))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2)
                )
                .shadow(radius: 5)
            Spacer()
            ElementsUI().customTextField("Enter app name", text: $appName)
                .frame(width: 350)
            Spacer()
            HStack(spacing: 20) {
                ElementsUI().customButton("Choose Image", width: 135, action: {
                    selectImage()
                })
                
                ElementsUI().customButton("Generate", width: 135, action: {
                    if !promt.isEmpty || !appName.isEmpty || promt.starts(with: " ") {
                        callCloudflareAIForDescription(prompt: promt, appName: appName)
                    } else {
                        showAlert(message: "All fields should be filled!")
                    }
                })
            }.padding(.bottom, 20)
            
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.5))
                .frame(width: 400)
                .padding(10)
        )
        .frame(maxWidth: 500, maxHeight: 600)
    }
    

    // MARK: - Result UI
    private var resultUI: some View {
        VStack(spacing: 20) {
            
            
            HStack(spacing: 30) {
                resultItem(title: "App Name:", content: parsedAppName)
                resultItem(title: "Subtitle:", content: parsedSubtitle)
            }
            
            resultItem(title: "Description:", content: parsedDescription)
                .frame(maxHeight: 200)
            
            resultItem(title: "Keywords:", content: parsedKeys)
                .padding(.horizontal, 40)
            
            actionButtons
                
            
            
        }
        .padding(.all, 50)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.6))
                .padding(10)
        )
        .frame(maxWidth: 600)
    }

    // MARK: - Components
    private func resultItem(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
           
                Text(content)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                    )
            
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 20) {
            ElementsUI().customButton("Try Again", width: 100, action: {
                generated = false
                generating = true
                parsedAppName = ""
                parsedSubtitle = ""
                parsedDescription = ""
                parsedKeys = ""
                callCloudflareAIForDescription(prompt: promt, appName: appName)
            })
            
            ElementsUI().customButton("Copy Description", width: 100, action: {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(description, forType: .string)
            })
            
            ElementsUI().customButton("Clear All", width: 100, action: {
                generated = false
                generating = false
                promt = ""
                appName = ""
                parsedAppName = ""
                parsedSubtitle = ""
                parsedDescription = ""
                parsedKeys = ""
                imageChosen = false
                selectedImage = ""
                firstTime = true
            })
            
        }
    }
    
    func selectImage() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.png, .jpeg]
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK {
            if let url = panel.url {
                imageChosen = true
                
                
                let imagePath = url.path
               // print("Image path: \(imagePath)")
                
                uploadImageToCloudinary(imagePath: imagePath) { result in
                    if let uploadedURL = result {
                       // print("Upload successful: \(uploadedURL)")
                        selectedImage = uploadedURL
                    } else {
                        print("Upload failed")
                    }
                }
            }
        }
    }
    func uploadImageToCloudinary(imagePath: String, completion: @escaping (String?) -> Void) {
        //qwerty
        let cloudName = ApiKeys.cloudinaryName
        
        guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) else {
            print("Failed to load image data.")
            completion(nil)
            return
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("unsigned_preset\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received from Cloudinary.")
                completion(nil)
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
               // print("Cloudinary Response: \(responseString)")
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let url = json["secure_url"] as? String {
                        completion(url)
                    } else if let error = json["error"] as? [String: Any],
                              let message = error["message"] as? String {
                        print("Cloudinary error: \(message)")
                        completion(nil)
                    } else {
                        print("Unexpected response structure: \(json)")
                        completion(nil)
                    }
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }


    func callCloudflareAIForDescription(prompt: String, appName: String) {
        generating = true
        let requestBody: [String: Any] = [
            "prompt": """
            Generate long description in english for my app's App Store page. The name of the app is \(appName), and the concept is \(prompt) make it look appealing to the user by making the text richer.
            Generate a short subtitle in english not bigger then 30 characters for the ios app named \(appName). The app description is: \(prompt). 
            Generate relevant 10 keywords in english for the ios app named \(appName). The app description is: \(prompt). Do not use ** to format text and Write just the response and nothing else separated by commas. Format of the response: 
            App Name: <Actual app name>
            Subtitle: <Actual Subtitle>
            Description: <Actual Description>
            Keys: <Actual Keys>
            Write just the response and nothing else
            """
        ]
        makeAPICall(with: requestBody) { response in
            DispatchQueue.main.async {
                self.generating = false
                self.description = response
                parseResponse(response)
                self.generated = true
                if firstTime {
                    if imageChosen {
                        addBlockToNotionPageImage(content: promt, imageURL: selectedImage)
                    } else {
                        addBlockToNotionPage(content: promt)
                    }
                }
                self.firstTime = false
            }
        }
    }
    
    func makeAPICall(with requestBody: [String: Any], completion: @escaping (String) -> Void) {
        //qwerty
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

    func parseResponse(_ response: String) {
        let lines = response.split(separator: "\n")
        for line in lines {
            if line.starts(with: "App Name:") {
                parsedAppName = line.replacingOccurrences(of: "App Name: ", with: "")
            } else if line.starts(with: "Subtitle:") {
                parsedSubtitle = line.replacingOccurrences(of: "Subtitle: ", with: "")
            } else if line.starts(with: "Description:") {
                parsedDescription = line.replacingOccurrences(of: "Description: ", with: "")
            } else if line.starts(with: "Keys:") {
                parsedKeys = line.replacingOccurrences(of: "Keys: ", with: "")
            }
        }
    }
    
    func addBlockToNotionPageImage(content: String, imageURL: String) {
        //qwerty
        let notionApiToken = ApiKeys.notionKey

        guard let url = URL(string: "https://api.notion.com/v1/blocks/\(notionPageId)/children") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(notionApiToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2022-06-28", forHTTPHeaderField: "Notion-Version")

        var children: [[String: Any]] = [
            [
                "object": "block",
                "type": "callout",
                "callout": [
                    "rich_text": [
                        [
                            "type": "text",
                            "text": [
                                "content": content
                            ]
                        ]
                    ],
                    "icon": [
                        "type": "emoji",
                        "emoji": "💡"
                    ],
                    "color": "yellow_background"
                ]
            ]
        ]

         
        children.append([
            "object": "block",
            "type": "image",
            "image": [
                "type": "external",
                "external": [
                    "url": imageURL
                ]
            ]
        ])

        

        let body: [String: Any] = [
            "children": children
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to encode Notion request body: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding block to Notion: \(error.localizedDescription)")
                return
            }

            if let response = response as? HTTPURLResponse {
                //print("Status Code: \(response.statusCode)")
            }

            if let data = data {
               // print("Response Data: \(String(data: data, encoding: .utf8) ?? "No Data")")
            }
        }

        task.resume()
    }
    
    func addBlockToNotionPage(content: String) {
        let notionApiToken = "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"

        guard let url = URL(string: "https://api.notion.com/v1/blocks/\(notionPageId)/children") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(notionApiToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2022-06-28", forHTTPHeaderField: "Notion-Version")

        var children: [[String: Any]] = [
            [
                "object": "block",
                "type": "callout",
                "callout": [
                    "rich_text": [
                        [
                            "type": "text",
                            "text": [
                                "content": content
                            ]
                        ]
                    ],
                    "icon": [
                        "type": "emoji",
                        "emoji": "💡"
                    ],
                    "color": "yellow_background"
                ]
            ]
        ]
        

        let body: [String: Any] = [
            "children": children
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to encode Notion request body: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding block to Notion: \(error.localizedDescription)")
                return
            }

            if let response = response as? HTTPURLResponse {
               // print("Status Code: \(response.statusCode)")
            }

            if let data = data {
               // print("Response Data: \(String(data: data, encoding: .utf8) ?? "No Data")")
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
