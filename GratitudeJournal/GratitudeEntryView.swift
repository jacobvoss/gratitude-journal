//
//  GratitudeEntryView.swift
//  GratitudeJournal
//
//  Created by Jacob Voss on 17.03.23.
//

import SwiftUI
import CoreData

struct GratitudeEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var details = ""
    @State private var selectedMood: Mood = .happy

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("What are you grateful for?", text: $title)
                }

                Section(header: Text("Details")) {
                    TextField("Add more details about your gratitude.", text: $details)
                }

                Section(header: Text("Mood")) {
                    Picker("Mood", selection: $selectedMood) {
                        ForEach(Mood.allCases, id: \.self) { mood in
                            Text(mood.emoji).tag(mood)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("New Entry", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(title.isEmpty)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                }
            }
            .foregroundColor(/*@START_MENU_TOKEN@*/Color("DarkBlue")/*@END_MENU_TOKEN@*/)
        }
    }

    private func saveEntry() {
        let newEntry = GratitudeEntry(context: viewContext)
        newEntry.title = title
        newEntry.details = details
        newEntry.date = Date()
        newEntry.mood = selectedMood.rawValue

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct GratitudeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        GratitudeEntryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
