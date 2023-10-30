//
//  ContentView.swift
//  GratitudeJournal
//
//  Created by Jacob Voss on 17.03.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: GratitudeEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GratitudeEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<GratitudeEntry>

    @State private var showingAddEntry = false
    
    private var moodCounts: [Mood: Int] {
        var counts: [Mood: Int] = [.happy: 0, .neutral: 0, .sad: 0]
        for entry in entries {
            if let mood = Mood(rawValue: entry.mood) {
                counts[mood, default: 0] += 1
            }
        }
        return counts
    }

    var body: some View {
        TabView {
            ZStack {
                if !entries.isEmpty {
                    VStack {
                        LinearGradient(gradient: Gradient(colors: [Color("PastelBlue"), Color("DarkBlue")]),
                                       startPoint: .top,
                                       endPoint: .bottom)
                            .edgesIgnoringSafeArea(.top)
                            .frame(height: 200)
                        
                        Spacer()
                    }
                }
                
                VStack {
                    if !entries.isEmpty {
                        Text("Gratitude Journal")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding(.top)
                            .foregroundColor(.white)
                        
                        Text("A daily practice of gratitude to improve mental well-being.")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        HStack {
                            VStack {
                                Text("Total Entries")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                Text("\(entries.count)")
                                    .font(.title)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color.white)
                            }
                            Spacer()
                            ForEach(Mood.allCases, id: \.self) { mood in
                                VStack {
                                    Text(mood.emoji)
                                        .font(.title)
                                    Text("\(moodCounts[mood] ?? 0)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .foregroundColor(Color("DarkBlue"))

                        if entries.isEmpty {
                            Text("No entries yet. Tap the plus button to add a new entry.")
                                .font(.title2)
                                .foregroundColor(Color("DarkBlue"))
                                .padding()
                        } else {
                            List {
                                ForEach(entries) { entry in
                                    GratitudeEntryRow(entry: entry)
                                }
                                .onDelete(perform: deleteEntries)
                            }
                        }
                    } else {
                        VStack {
                            Text("Gratitude Journal")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(Color("DarkBlue"))
                                .shadow(color: .gray, radius: 2, x: 0, y: 2)
                            
                            Text("No entries yet. Tap the plus button to add a new entry.")
                                .font(.title2)
                                .foregroundColor(Color("DarkBlue"))
                                .padding()
                        }
                    }

                    Button(action: { showingAddEntry.toggle() }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundColor(Color("DarkBlue"))
                    }
                    .padding(.bottom)
                    .sheet(isPresented: $showingAddEntry) {
                        GratitudeEntryView().environment(\.managedObjectContext, viewContext)
                    }
                                    }
                                }
                                .foregroundColor(Color("DarkBlue"))
                                .tabItem {
                                    Image(systemName: "book.fill")
                                    Text("Journal")
                                }
                                
                                ExportView()
                                    .environment(\.managedObjectContext, viewContext)
                                    .tabItem {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("Export")
                                    }
                            }
                        }

                        private func deleteEntries(offsets: IndexSet) {
                            offsets.map { entries[$0] }.forEach(viewContext.delete)

                            do {
                                try viewContext.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                    }

                    struct ContentView_Previews: PreviewProvider {
                        static var previews: some View {
                            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                        }
                    }
