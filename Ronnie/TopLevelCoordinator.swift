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
    }

    func start() {
        logger.info("Starting.")
    }
}
