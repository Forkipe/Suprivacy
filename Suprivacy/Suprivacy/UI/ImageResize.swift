
import SwiftUI
import Lottie

struct ImageResizeView: View {
    @State private var resizedImages: [NSImage] = []
    @State private var isProcessing = false
    @State private var isPulsing = false
    var body: some View {
        ZStack {
            LottieView(animation: .named("Animation - 1734730219117"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            VStack {
                if isProcessing {
                    ProgressView("Processing...")
                } else if !resizedImages.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(resizedImages.indices, id: \.self) { index in
                                Image(nsImage: resizedImages[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 400)
                                    .padding()
                            }
                            
                        }
                    }.padding(.horizontal, 250)
                    
                    
                    HStack {
                        ElementsUI().customButton("Save Images", width: 200, action: {
                            saveImages()
                        })
                        
                        ElementsUI().customButton("Clear All", width: 200, action: {
                            resizedImages = []
                        })
                    }
                } else {
                    VStack {
                        ElementsUI().title("Select images to resize and compress")
                        Spacer()
                        ZStack {
                            LottieView(animation: .named("ButtonBg"))
                                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                                .animationSpeed(0.4)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350, height: 350)
                            
                            
                            ElementsUI().customButton("Select Images", width: 200, action: {
                                selectImages()
                            })
                            .scaleEffect(isPulsing ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                                value: isPulsing
                            )
                            .onAppear {
                                isPulsing = true
                            }
                        }
                        Spacer()
                    }
                }
            }
            .padding()
        }
    }
    
    func selectImages() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.png, .jpeg]
        panel.allowsMultipleSelection = true
        if panel.runModal() == .OK {
            let urls = panel.urls
            processImages(from: urls)
        }
    }
    
    func processImages(from urls: [URL]) {
        isProcessing = true
        DispatchQueue.global(qos: .userInitiated).async {
            let resized = urls.compactMap { resizeImage(at: $0, toWidth: 1242/2, toHeight: 2688/2) }
            DispatchQueue.main.async {
                self.resizedImages = resized
                self.isProcessing = false
            }
        }
    }
    
    func resizeImage(at url: URL, toWidth width: CGFloat, toHeight height: CGFloat) -> NSImage? {
        guard let image = NSImage(contentsOf: url) else { return nil }
        let newImage = NSImage(size: NSSize(width: width, height: height))
        newImage.lockFocus()
        
        let imageRect = NSRect(x: 0, y: 0, width: width, height: height)
        image.draw(in: imageRect, from: NSRect(origin: .zero, size: image.size), operation: .copy, fraction: 1.0)
        
        newImage.unlockFocus()
        return newImage
    }
    
    func saveImages() {
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.title = "Select Folder to Save Images"
        panel.prompt = "Save"
        panel.nameFieldStringValue = "ResizedImages"
        
        if panel.runModal() == .OK, let directoryURL = panel.url {
            let fileManager = FileManager.default
            do {
                if !fileManager.fileExists(atPath: directoryURL.path) {
                    try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                }
                
                resizedImages.enumerated().forEach { index, image in
                    let fileURL = directoryURL.appendingPathComponent("image_\(index + 1).png")
                    
                    compressAndSaveImage(image, to: fileURL) { success in
                        if success {
                           // print("Image \(index + 1) saved successfully.")
                        } else {
                           // print("Failed to save image \(index + 1).")
                        }
                    }
                }
            } catch {
                print("Failed to create directory or save images: \(error.localizedDescription)")
            }
        }
    }
    
    func compressAndSaveImage(_ image: NSImage, to url: URL, completion: @escaping (Bool) -> Void) {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            print("Failed to convert image to PNG")
            completion(false)
            return
        }
        
        let tinyPngURL = URL(string: "https://api.tinify.com/shrink")!
        let apiKey = ApiKeys.tintifyKey
        var request = URLRequest(url: tinyPngURL)
        request.httpMethod = "POST"
        let credentials = "\(apiKey):".data(using: .utf8)!.base64EncodedString()
        request.addValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        request.httpBody = pngData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                print("TinyPNG API Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let output = json["output"] as? [String: Any],
               let downloadURLString = output["url"] as? String,
               let downloadURL = URL(string: downloadURLString) {
                
                URLSession.shared.dataTask(with: downloadURL) { optimizedData, _, downloadError in
                    guard let optimizedData = optimizedData, downloadError == nil else {
                        print("Failed to download optimized image.")
                        completion(false)
                        return
                    }
                    
                    do {
                        try optimizedData.write(to: url)
                        completion(true)
                    } catch {
                        print("Failed to save compressed image: \(error.localizedDescription)")
                        completion(false)
                    }
                }.resume()
            } else {
                print("Failed to parse TinyPNG API response.")
                completion(false)
            }
        }.resume()
    }
}
