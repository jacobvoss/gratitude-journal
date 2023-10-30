//
//  GratitudeJournalApp.swift
//  GratitudeJournal
//
//  Created by Jacob Voss on 17.03.23.
//

import SwiftUI

@main
struct GratitudeJournalApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(Color("PastelBlue"))
        coloredNavAppearance.backgroundImage = UIImage.gradientImageWithBounds(
            bounds: CGRect(x: 0, y: 0, width: 1, height: 100),
            colors: [UIColor(Color("DarkBlue")), UIColor.white]
        )
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color("DarkBlue"))]

        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [UIColor]) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
