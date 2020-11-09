//
//  URLImageOptionsView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 18/10/2020.
//

import SwiftUI
import URLImage


struct URLImageOptionsView: View {

    var isRemoveCachedImagesButtonVisible: Bool

    init(isRemoveCachedImagesButtonVisible: Bool = true) {
        self.isRemoveCachedImagesButtonVisible = isRemoveCachedImagesButtonVisible
    }

    @EnvironmentObject private var appConfiguration: AppConfiguration

    @State private var isInitial = true

    @State private var selectedCachePolicy: CachePolicy = .returnCacheElseLoad

    /// Cache delay for `returnCacheElseLoad`
    @State private var isCacheDelayOn = false
    @State private var cacheDelayInput: String = ""

    /// Download delay for `returnCacheElseLoad`
    @State private var isDownloadDelayOn = false
    @State private var downloadDelayInput: String = ""

    /// Delay for `returnCacheDontLoad` and `ignoreCache`
    @State private var isDelayOn = false
    @State private var delayInput: String = ""

    @State private var expiryIntervalInput: String = ""

    @State private var widthInput: String = ""
    @State private var heightInput: String = ""

    // LoadOptions
    @State private var isLoadImmediately = false
    @State private var isLoadOnAppear = false
    @State private var isCancelOnDisappear = false
    @State private var isInMemory = false

    var body: some View {
        Form {
            Section(header: Text("Cache")) {
                Picker("Policy", selection: $selectedCachePolicy) {
                    Text(CachePolicy.returnCacheElseLoad.rawValue).tag(CachePolicy.returnCacheElseLoad)
                    Text(CachePolicy.returnCacheDontLoad.rawValue).tag(CachePolicy.returnCacheDontLoad)
                    Text(CachePolicy.ignoreCache.rawValue).tag(CachePolicy.ignoreCache)
                }

                switch selectedCachePolicy {
                    case .returnCacheElseLoad:
                        Toggle(isOn: $isCacheDelayOn.animation(), label: {
                            Text("Delay Cache Lookup")
                        })

                        if isCacheDelayOn {
                            TextField("Cache Delay", text: $cacheDelayInput)
                                .keyboardType(.numberPad)
                        }
                        
                        Toggle(isOn: $isDownloadDelayOn.animation(), label: {
                            Text("Delay Download")
                        })

                        if isDownloadDelayOn {
                            TextField("Cache Delay", text: $downloadDelayInput)
                                .keyboardType(.numberPad)
                        }

                    case .returnCacheDontLoad:
                        Toggle(isOn: $isDelayOn.animation(), label: {
                            Text("Delay Cache Lookup")
                        })

                        if isDelayOn {
                            TextField("Cache Delay", text: $delayInput)
                                .keyboardType(.numberPad)
                        }

                    case .ignoreCache:
                        Toggle(isOn: $isDelayOn.animation(), label: {
                            Text("Delay Download")
                        })

                        if isDelayOn {
                            TextField("Download Delay", text: $delayInput)
                                .keyboardType(.numberPad)
                        }
                }
            }
            Section(header: Text("Expire After")) {
                TextField("Expire After", text: $expiryIntervalInput)
                    .keyboardType(.numberPad)
            }
            Section(header: Text("Size")) {
                HStack {
                    TextField("Width", text: $widthInput)
                        .keyboardType(.numberPad)
                    Text("x")
                    TextField("Height", text: $heightInput)
                        .keyboardType(.numberPad)
                }
            }
            Section(header: Text("Load Options")) {
                Toggle(isOn: $isLoadImmediately, label: {
                    Text("Load Immediately")
                })
                Toggle(isOn: $isLoadOnAppear, label: {
                    Text("Load On Appear")
                })
                Toggle(isOn: $isCancelOnDisappear, label: {
                    Text("Cancel On Disappear")
                })
                Toggle(isOn: $isInMemory, label: {
                    Text("Download in memory")
                })
            }
            if isRemoveCachedImagesButtonVisible {
                Section {
                    Button("Remove Cached Images") {
                        URLImageService.shared.removeAllCachedImages()
                    }
                }
            }
        }
        .onAppear {
            guard isInitial else {
                return
            }

            isInitial = false

            switch appConfiguration.urlImageOptions.cachePolicy {
                case .returnCacheElseLoad(let cacheDelay, let downloadDelay):
                    selectedCachePolicy = .returnCacheElseLoad

                    if let cacheDelay = cacheDelay {
                        isCacheDelayOn = true
                        cacheDelayInput = String(cacheDelay)
                    }
                    else {
                        isCacheDelayOn = false
                        cacheDelayInput = ""
                    }

                    if let downloadDelay = downloadDelay {
                        isDownloadDelayOn = true
                        downloadDelayInput = String(downloadDelay)
                    }
                    else {
                        isDownloadDelayOn = false
                        downloadDelayInput = ""
                    }

                case .returnCacheDontLoad(let delay):
                    selectedCachePolicy = .returnCacheDontLoad

                    if let delay = delay {
                        isDelayOn = true
                        delayInput = String(delay)
                    }
                    else {
                        isDelayOn = false
                        delayInput = ""
                    }

                case .ignoreCache(let delay):
                    selectedCachePolicy = .ignoreCache

                    if let delay = delay {
                        isDelayOn = true
                        delayInput = String(delay)
                    }
                    else {
                        isDelayOn = false
                        delayInput = ""
                    }
            }

            if let expiryInterval = appConfiguration.urlImageOptions.expiryInterval {
                expiryIntervalInput = String(expiryInterval)
            }
            else {
                expiryIntervalInput = ""
            }

            if let size = appConfiguration.urlImageOptions.maxPixelSize {
                widthInput = String(Double(size.width))
                heightInput = String(Double(size.height))
            }

            isLoadImmediately = appConfiguration.urlImageOptions.loadOptions.contains(.loadImmediately)
            isLoadOnAppear = appConfiguration.urlImageOptions.loadOptions.contains(.loadOnAppear)
            isCancelOnDisappear = appConfiguration.urlImageOptions.loadOptions.contains(.cancelOnDisappear)
            isInMemory = appConfiguration.urlImageOptions.loadOptions.contains(.inMemory)
        }
        .onDisappear {
            switch selectedCachePolicy {
                case .returnCacheElseLoad:
                    let cacheDelay = isCacheDelayOn ? TimeInterval(cacheDelayInput) : nil
                    let downloadDelay = isDownloadDelayOn ? TimeInterval(downloadDelayInput) : nil
                    appConfiguration.urlImageOptions.cachePolicy = .returnCacheElseLoad(cacheDelay: cacheDelay, downloadDelay: downloadDelay)

                case .returnCacheDontLoad:
                    let delay = isDelayOn ? TimeInterval(delayInput) : nil
                    appConfiguration.urlImageOptions.cachePolicy = .returnCacheDontLoad(delay: delay)

                case .ignoreCache:
                    let delay = isDelayOn ? TimeInterval(delayInput) : nil
                    appConfiguration.urlImageOptions.cachePolicy = .ignoreCache(delay: delay)
            }

            appConfiguration.urlImageOptions.expiryInterval = TimeInterval(expiryIntervalInput)

            if let width = Double(widthInput), width > 0.0,
               let height = Double(widthInput), height > 0.0 {
                appConfiguration.urlImageOptions.maxPixelSize = CGSize(width: width, height: height)
            }
            else {
                appConfiguration.urlImageOptions.maxPixelSize = nil
            }

            var loadOptions = URLImageOptions.LoadOptions()

            if isLoadImmediately {
                loadOptions.formUnion(.loadImmediately)
            }

            if isLoadOnAppear {
                loadOptions.formUnion(.loadOnAppear)
            }

            if isCancelOnDisappear {
                loadOptions.formUnion(.cancelOnDisappear)
            }

            if isInMemory {
                loadOptions.formUnion(.inMemory)
            }

            appConfiguration.urlImageOptions.loadOptions = loadOptions
        }
    }

    private enum CachePolicy: String, CaseIterable, Identifiable {

        case returnCacheElseLoad = "Return Cache, Else Load"

        case returnCacheDontLoad = "Return Cache, Don't Load"

        case ignoreCache = "Ignore Cache"

        var id: String {
            rawValue
        }
    }
}

//struct URLImageOptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        URLImageOptionsView()
//    }
//}
