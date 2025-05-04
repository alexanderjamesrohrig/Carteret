//
//  MailComposeView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 2/27/25.
//

#if canImport(MessageUI)
import MessageUI
import SwiftUI
import OSLog

struct MailComposeView: UIViewControllerRepresentable {
    class Coordinator: NSObject, @preconcurrency MFMailComposeViewControllerDelegate {
        init(_ parent: MFMailComposeViewController) {
            self.parent = parent
        }
        
        let parent: MFMailComposeViewController
        let logger = Logger(subsystem: Constant.carteretSubsystem,
                            category: "MailComposeViewControllerRepresentable")
        
        @MainActor
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: (any Error)?) {
            switch result {
            case .cancelled:
                logger.info("Cancelled")
            case .saved:
                logger.info("Saved")
            case .sent:
                logger.info("Sent")
            case .failed:
                logger.warning("Failed")
            @unknown default:
                logger.warning("Unknown")
            }
            if let error {
                logger.error("Mail error :- \(error.localizedDescription)")
            }
            parent.dismiss(animated: true)
        }
    }
    
    private let logger = Logger(subsystem: Constant.carteretSubsystem,
                                category: "MailComposeViewControllerRepresentable")
    private let viewController = MFMailComposeViewController(nibName: nil, bundle: nil)
    let toRecipients: [String]
    let subject: String
    let body: String
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: Context) {
        logger.info("\(#function)")
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        viewController.setToRecipients(toRecipients)
        viewController.setSubject(subject)
        viewController.setMessageBody(body, isHTML: false)
        viewController.mailComposeDelegate = context.coordinator
        return viewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewController)
    }
}
#endif
