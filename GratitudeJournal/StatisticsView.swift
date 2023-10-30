//
//  StatisticsView.swift
//  GratitudeJournal
//
//  Created by Jacob Voss on 17.03.23.
//

import SwiftUI
import CoreData

struct StatisticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: GratitudeEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GratitudeEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<GratitudeEntry>
    
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
        ZStack {
            VStack {
                LinearGradient(gradient: Gradient(colors: [Color("PastelBlue"), Color("DarkBlue")]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 200)
                
                Spacer()
            }
            
            VStack {
                Text("Statistics")
                    .font(.largeTitle)
                    .padding(.top)
                    .foregroundColor(.white)

                VStack(alignment: .center, spacing: 20) {
                    VStack {
                        Text("Total Entries")
                            .font(.title2)
                        HStack {
                            Image(systemName: "book.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("DarkBlue"))
                            Text("\(entries.count)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .padding(.bottom)
                    }
                    .padding()
                    .background(Color("PastelBlue"))
                    .cornerRadius(10)
                    
                    VStack {
                        Text("Mood Distribution")
                            .font(.title2)
                            .padding(.bottom)
                        ForEach(Mood.allCases, id: \.self) { mood in
                            HStack {
                                Text(mood.emoji)
                                    .font(.largeTitle)
                                Text("\(moodCounts[mood] ?? 0)")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            .padding(.bottom)
                        }
                    }
                    .padding()
                    .background(Color("PastelBlue"))
                    .cornerRadius(10)
                }
                .padding()
                Spacer()
            }
            .foregroundColor(Color("DarkBlue"))
            .frame(maxWidth: 500)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
