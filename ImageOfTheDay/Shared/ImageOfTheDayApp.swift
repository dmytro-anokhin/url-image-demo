//
//  ImageOfTheDayApp.swift
//  Shared
//
//  Created by Dmytro Anokhin on 15/02/2021.
//

import SwiftUI
import URLImage
import URLImageStore
import BackgroundTasks


@main
struct ImageOfTheDayApp: App {

    @StateObject var feedList: FeedListObject = .shared

#if os(iOS)

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

#endif

    var body: some Scene {

        let fileStore = URLImageFileStore()
        let inMemoryStore = URLImageInMemoryStore()
        let urlImageService = URLImageService(fileStore: fileStore, inMemoryStore: inMemoryStore)

        return WindowGroup {
            FeedListView()
                .environment(\.urlImageService, urlImageService)
                .environmentObject(feedList)
        }
    }
}


#if os(iOS)

// Launch
// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"org.danokhin.ImageOfTheDay.refresh"]

// Terminate
// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"org.danokhin.ImageOfTheDay.refresh"]

class AppDelegate: NSObject, UIApplicationDelegate {

    static let backgroundRefreshInterval: TimeInterval = 15 * 60

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "org.danokhin.ImageOfTheDay.refresh", using: nil) { task in
             self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }

        scheduleAppRefresh()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }

    private func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "org.danokhin.ImageOfTheDay.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: AppDelegate.backgroundRefreshInterval)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    private func handleAppRefresh(task: BGAppRefreshTask) {
        // Schedule a new refresh task
        scheduleAppRefresh()

        task.expirationHandler = {
            // TODO: Cancel load
        }

        FeedListObject.shared.update {
            task.setTaskCompleted(success: $0)
        }
     }
}

#endif
