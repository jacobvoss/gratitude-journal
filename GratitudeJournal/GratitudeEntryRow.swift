//
//  GratitudeEntryRow.swift
//  GratitudeJournal
//
//  Created by Jacob Voss on 17.03.23.
//

import SwiftUI
import CoreData

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

struct GratitudeEntryRow: View {
    let entry: GratitudeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(Mood(rawValue: entry.mood)?.emoji ?? "")
                    .font(.largeTitle)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .cornerRadius(22)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                
                Image(systemName: "calendar")
                    .foregroundColor(Color("PastelBlue"))
                    .font(.system(size: 22))
                
                VStack(alignment: .leading) {
                    Text(entry.title ?? "")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(entry.date!, formatter: dateFormatter)
                        .font(.caption)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            Text(entry.details ?? "")
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding([.horizontal, .top])
    }
}

struct GratitudeEntryRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let request: NSFetchRequest<GratitudeEntry> = GratitudeEntry.fetchRequest()
        request.fetchLimit = 1

        let entries = try? context.fetch(request)
        let entry = entries?.first ?? GratitudeEntry(context: context)

        return GratitudeEntryRow(entry: entry)
            .previewLayout(.sizeThatFits)
    }
}
