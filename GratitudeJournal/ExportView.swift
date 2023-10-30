//
//  ExportView.swift
//  GratitudeJournal
//
//  Created by Jacob Voss on 17.03.23.
//

import SwiftUI
import CoreData
import Foundation

struct ExportView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: GratitudeEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GratitudeEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<GratitudeEntry>
    
    @State private var isSharing: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Export Gratitude Entries")
                .font(.title)
            Text("Export all your gratitude entries as a CSV file.")
                .multilineTextAlignment(.center)
                .padding()
            Button(action: {
                isSharing = true
            }) {
                Text("Export Entries")
                    .padding()
                    .background(Color("DarkBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isSharing) {
                ActivityView(shareItems: generateCSV(), completionHandler: { _, _, _, _ in
                    isSharing = false
                })
            }
            Spacer()
        }
        .padding()
    }

    private func generateCSV() -> URL? {
        let fileName = "GratitudeJournal.csv"
        var csvText = "Date,Title,Details,Mood\n"

        for entry in entries {
            let dateString = entry.date.map { String(describing: $0) } ?? "Unknown"
            let title = entry.title ?? "Unknown"
            let details = entry.details ?? "Unknown"
            let mood = Mood(rawValue: entry.mood)?.emoji ?? "Unknown"

            csvText.append("\(dateString),\(title),\(details),\(mood)\n")
        }

        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)

        do {
            try csvText.write(to: fileURL!, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Failed to write CSV file: \(error.localizedDescription)")
            return nil
        }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    var shareItems: URL?
    var completionHandler: UIActivityViewController.CompletionWithItemsHandler?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: shareItems.map { [$0] } ?? [], applicationActivities: nil)
        controller.completionWithItemsHandler = completionHandler
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
