import Logging
import UIKit

class TopLevelCoordinator {
    let rootViewController: UISplitViewController
    let logger = Logger(label: "TopLevelCoordinator")

    let projectsTableViewController = UITableViewController(style: .plain)
    let projectItemsTableViewController = UITableViewController(style: .plain)
    let contentViewController = UIViewController()

    init() {
        rootViewController = UISplitViewController(style: .tripleColumn)

        rootViewController.setViewController(projectsTableViewController, for: .primary)
        rootViewController.setViewController(projectItemsTableViewController, for: .supplementary)
        rootViewController.setViewController(contentViewController, for: .secondary)

        createSampleDataIfNeeded()
    }

    func start() {
        logger.info("Starting.")
    }

    func createSampleDataIfNeeded() {
        guard let iCloudToken = FileManager.default.ubiquityIdentityToken else {
            logger.critical("iCloud is not available or the user is not lgoged in.")
            return
        }

        guard let url = FileManager.default.url(forUbiquityContainerIdentifier: nil) else {
            logger.critical("Could not find a URL for the app's main iCloud container")
            return
        }

        logger.debug("URL is \(url)")

        do {
            let subDirs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            logger.info("\(subDirs.count) subdirs.")
            subDirs.forEach { url in
                logger.debug("\(url)")
            }

            let basicFolderURL = url.appendingPathComponent(UUID().uuidString)
            try FileManager.default.createDirectory(at: basicFolderURL, withIntermediateDirectories: true, attributes: nil)

            let helloWorldURL = url.appendingPathComponent("Documents").appendingPathComponent("hello-ronnie.txt")
            let content = "Hello Ronnie!"
            try content.write(to: helloWorldURL, atomically: true, encoding: .utf8)

            logger.info("Successfully created sample data.")
        } catch {
            logger.error("An exception occurred: \(error)")
        }
    }
}
