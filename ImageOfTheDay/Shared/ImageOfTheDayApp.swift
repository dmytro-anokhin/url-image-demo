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

#if os(iOS)

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

#endif

    var body: some Scene {

        let fileStore = URLImageFileStore()
        let inMemoryStore = URLImageInMemoryStore()
        let urlImageService = URLImageService(fileStore: fileStore, inMemoryStore: inMemoryStore)

        return WindowGroup {
            ContentView()
                .environment(\.urlImageService, urlImageService)
        }
    }
}


#if os(iOS)

// Launch
// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"org.danokhin.ImageOfTheDay.refresh"]

// Terminate
// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"org.danokhin.ImageOfTheDay.refresh"]

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "org.danokhin.ImageOfTheDay.refresh", using: nil) { task in
             self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }

        scheduleAppRefresh()

        return true
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "org.danokhin.ImageOfTheDay.refresh")

        // Fetch no earlier than 15 minutes from now
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        // Schedule a new refresh task
        scheduleAppRefresh()

        // Create an operation that performs the main part of the background task
        // let operation = RefreshAppContentsOperation()

        // Provide an expiration handler for the background task
        // that cancels the operation
        task.expirationHandler = {
            //operation.cancel()
        }

        // Inform the system that the background task is complete
        // when the operation completes
//        operation.completionBlock = {
//            task.setTaskCompleted(success: !operation.isCancelled)
//        }
//
//        // Start the operation
//        operationQueue.addOperation(operation)



        task.setTaskCompleted(success: true)
     }
}

#endif
