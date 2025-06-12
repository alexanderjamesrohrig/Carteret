//
//  PlaidLinkView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/26/25.
//

import SwiftUI

#if canImport(LinkKit)
@preconcurrency import LinkKit

@available(iOS 17.2, *)
struct PlaidLinkView: UIViewControllerRepresentable {
    private let handler: Handler
    
    init(handler: Handler) {
        self.handler = handler
    }
    
    class Coordinator: NSObject {
        private let parent: PlaidLinkView
        private let handler: Handler
        
        init(parent: PlaidLinkView, handler: Handler) {
            self.parent = parent
            self.handler = handler
        }
        
        @MainActor
        func present(handler: Handler, viewController: UIViewController) {
            handler.open(presentUsing: .custom({ linkViewController in
                viewController.addChild(linkViewController)
                viewController.view.addSubview(linkViewController.view)
                linkViewController.view.translatesAutoresizingMaskIntoConstraints = false
                linkViewController.view.frame = viewController.view.bounds
                NSLayoutConstraint.activate([
                    linkViewController.view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
                    linkViewController.view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
                    linkViewController.view.widthAnchor.constraint(equalTo: viewController.view.widthAnchor),
                    linkViewController.view.heightAnchor.constraint(equalTo: viewController.view.heightAnchor),
                ])
                linkViewController.didMove(toParent: viewController)
            }))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, handler: handler)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        context.coordinator.present(handler: handler, viewController: viewController)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
#else
struct PlaidLinkView: View {
    var body: some View {
        ContentUnavailableView("Only available on iOS.", systemImage: "iphone.gen3")
    }
}
#endif
