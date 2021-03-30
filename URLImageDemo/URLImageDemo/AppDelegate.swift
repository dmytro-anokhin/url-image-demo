//
//  AppDelegate.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 17/10/2020.
//

import UIKit
import URLImage
import Combine


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var cancellable: AnyCancellable?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(URLImageService.shared.diskCacheURL.path)

//        let url = URL(string: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")!
//        let cancellable = URLImageService.shared.remoteImagePublisher(url)
//            .tryMap { $0.cgImage }
//            .sink { image in
//                print(image)
//            }
//
//        let urls = [
//            URL(string: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")!,
//            URL(string: "https://homepages.cae.wisc.edu/~ece533/images/lena.png")!,
//            URL(string: "https://localhost")!
//        ]
//
//        let publishers = urls.map { URLImageService.shared.remoteImagePublisher($0) }
//
//        cancellable = Publishers.MergeMany(publishers)
//            .tryMap { $0.cgImage }
//            .catch { _ in
//                Just(nil)
//            }
//            .collect()
//            .sink { results in
//                print(results)
//            }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

