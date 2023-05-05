//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by dexiong on 2023/5/4.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WidgetExtensionEntryView : View {
    @Environment(\.widgetFamily) var family
    
    private var records: [Record.Abstract] { DataBase.shared.records() }
    
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            if let image = UIImage(named: "charleyrivers") {
                Image(uiImage: image)
            } else {
                Image(systemName: "star")
            }
        case .systemMedium:
            if let image = UIImage(named: "charleyrivers_feature") {
                Image(uiImage: image)
            } else {
                Image(systemName: "star")
            }
        case .systemLarge:
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Text("\(records.count)")
                            .foregroundColor(.primary)
                            .font(.system(size: 20, weight: .bold))
                        Text("提醒")
                            .foregroundColor(.orange)
                            .font(.system(size: 14, weight: .bold))
                    }
                    Spacer()
                    Button {
                        print("点击我了")
                    } label: {
                        Image(systemName: "list.bullet.rectangle")
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white)
                            .background(.yellow)
                            .clipped()
                            .cornerRadius(22)
                    }
                }
                Divider()
                if records.isEmpty == false {
                    let range: Range = .init(uncheckedBounds: (0, min(6, records.count)))
                    ForEach(range) { index in
                        let obj = records[index]
                        HStack {
                            Link(destination: obj.objectID.uriRepresentation()) {
                                Text(obj.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                        }
                        .padding(.zero)
                        Divider()
                    }
                    if records.count > range.upperBound {
                        HStack {
                            Text("+\(records.count - range.upperBound) More")
                                .font(.headline)
                                .foregroundColor(.orange)
                            Spacer()
                        }
                        .padding(.zero)
                    }
                } else {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        Text("暂无数据")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding()
        case .systemExtraLarge:
            Text("systemExtraLarge")
        case .accessoryCorner:
            Text("accessoryCorner")
        case .accessoryCircular:
            Text("accessoryCircular")
        case .accessoryRectangular:
            Text("accessoryRectangular")
        case .accessoryInline:
            Text("accessoryInline")
        @unknown default:
            fatalError()
        }
    }
}

struct WidgetExtension: Widget {
    
    let kind: String = "WidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        WidgetExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
