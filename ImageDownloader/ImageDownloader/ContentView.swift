//
//  ContentView.swift
//  ImageDownloader
//
//  Created by Dmytro Anokhin on 30/03/2021.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers
import URLImage


/// Document used to export image as JPEG file using system dialog
fileprivate struct JPEGExportDocument: FileDocument {

    enum JPEGExportError: Error {

        /// Can not create JPEG representation of the image
        case create
    }

    static let readableContentTypes: [UTType] = []

    static let writableContentTypes: [UTType] = [ .jpeg ]

    let cgImage: CGImage

    let compressionQuality: CGFloat

    init(configuration: ReadConfiguration) throws {
        preconditionFailure("ImageDocument can not read data")
    }

    init(cgImage: CGImage, compressionQuality: CGFloat = 1.0) {
        self.cgImage = cgImage
        self.compressionQuality = compressionQuality
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let uiImage = UIImage(cgImage: cgImage)

        guard let data = uiImage.jpegData(compressionQuality: compressionQuality) else {
            throw JPEGExportError.create
        }

        return FileWrapper(regularFileWithContents: data)
    }
}

/// The `Model` object implements image load logic using `URLImage` service and manages `JPEGExportDocument` instance.
///
/// `Model` class  conforms to `ObservableObject` protocol to notify observers when download completed and the document is ready for export.
fileprivate final class Model: ObservableObject {

    /// URL of the image to download
    let url: URL

    init(url: URL) {
        self.url = url
    }

    @Published private(set) var document: JPEGExportDocument? = nil

    var isLoaded: Bool {
        document != nil
    }

    func load() {
        guard document == nil && cancellable == nil else { // Already loaded or loading
            return
        }

        cancellable = URLImageService.shared
            .remoteImagePublisher(url, options: URLImageOptions(maxPixelSize: nil))
            .tryMap {
                $0.cgImage
            }
            .catch { _ in
                Just(nil)
            }
            .sink { [weak self] image in
                guard let self = self else {
                    return
                }

                if let image = image {
                    self.document = JPEGExportDocument(cgImage: image)
                }
            }
    }

    private var cancellable: AnyCancellable?
}


struct ContentView: View {

    let url = URL(string: "http://sipi.usc.edu/database/download.php?vol=misc&img=4.1.07")!

    init() {
        model = Model(url: url)
    }

    var body: some View {
        NavigationView {
            URLImage(url: model.url) {
                $0.resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .onAppear {
                model.load()
            }
            .navigationTitle(url.absoluteString)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    // Show export button only if the image is downloaded
                    if model.isLoaded {
                        Button(action: {
                            isFileExportPresented.toggle()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
            .fileExporter(isPresented: $isFileExportPresented, document: model.document, contentType: .jpeg) {
                // TODO: Handle the result
                print($0)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    /// State of file export dialog presentation
    @State private var isFileExportPresented = false

    @ObservedObject private var model: Model
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
