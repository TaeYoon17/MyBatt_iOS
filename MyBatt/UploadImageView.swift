
import SwiftUI

struct UploadImageView: View {
    @State private var image: UIImage? = nil
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Button("Upload Image") {
                guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
                    print("Failed to convert image to JPEG data")
                    return
                }
                
                let url = URL(string: "3.34.15.237:8080/savefile")!
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        return
                    }
                    
                    print("Image uploaded successfully!")
                }
                
                task.resume()
            }
        }
        .onAppear {
            // Load example image
            image = UIImage(named: "hello")
        }
    }
}

struct UploadImageView_Previews: PreviewProvider {
    static var previews: some View {
        UploadImageView()
    }
}
