//
//  TestWidget.swift
//  TestWidget
//
//  Created by smalltalk on 25/6/2020.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    public func snapshot(for configuration: TestWidgetConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    public func timeline(for configuration: TestWidgetConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        // 读取了设置中的参数, 实际上并不用,只是展示一下这个功能怎么写
        let userName = configuration.userName ?? ""
        let showFullName = configuration.showFullName?.boolValue ?? true
        
        //此处并不着急completion(),可以发起网络请求等
        /*
         let reqUrl = URL(string: "https://api.xygeng.cn/Bing")!
         let task = URLSession.shared.dataTask(with: reqUrl) { (data, response, error) in
             guard error == nil else {
                 let entryDate = Calendar.current.date(byAdding: .second, value: 20, to: Date())!
                 let entry = SimpleEntry(date: entryDate)
                 let timeline = Timeline(entries: [entry], policy: .after(entryDate))
                 completion(timeline)
                return
             }
             let _ = getCommitInfo(fromData: data!)
                 let entryDate = Calendar.current.date(byAdding: .second, value: 20, to: Date())!
                 let entry = SimpleEntry(date: entryDate)
                 let timeline = Timeline(entries: [entry], policy: .after(entryDate))
                 completion(timeline)
             }
          task.resume()
         */
        
        //本代码 在 2 秒后刷新界面
        let entryDate = Calendar.current.date(byAdding: .second, value: 2, to: Date())!
        let entry = SimpleEntry(date: entryDate)
        let timeline = Timeline(entries: [entry], policy: .after(entryDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct TestWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
            case .systemSmall:
                ZStack {
                    Color(red: 0.55, green: 0.73, blue: 1.0)
                    VStack(spacing: 10) {
                        PhotoView(imageName: "aragaki")
                    }
                }
            case .systemMedium:
                ZStack {
                    Color(red:0.61, green:0.35, blue:0.71)
                    HStack(spacing: 10) {
                        PhotoView(imageName: "aragaki2")
                        Text("Aragaki")
                            .font(Font.system(size: 18))
                            .fontWeight(.heavy)
                            .shadow(color: Color.gray, radius: 5, x: 2, y: 2)
                        
                    }
                }
            default:
                ZStack {
                    Color(red:0.97, green:0.54, blue:0.88)
                    VStack {
                        HStack(spacing: 10) {
                            PhotoView(imageName: "aragaki3")
                            Text("Aragaki")
                                .font(Font.system(size: 18))
                                .fontWeight(.heavy)
                                .shadow(color: Color.gray, radius: 5, x: 2, y: 2)
                            
                        }
                        
                        Text("Aragaki")
                            .font(Font.system(size: 18))
                            .fontWeight(.heavy)
                            .shadow(color: Color.gray, radius: 5, x: 2, y: 2)
                        
                    }
                }
        }
    }
}

@main
struct TestWidget: Widget {
    private let kind: String = "TestWidget"
    /*
     .configurationDisplayName("My Widget") //名字,会显示在插件中心和设置页面
     .description("This is an example widget.") // 介绍,会显示在插件中心和设置页面
     .supportedFamilies([.systemSmall, .systemMedium, .systemLarge]) // 可以不写,默认支持全部
     */
    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: TestWidgetConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
            TestWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}


// 附加的视图,显得代码高级
struct PhotoView : View {
    
    let imageName: String
    
    var body: some View {
        
        return Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 180.0, height: 180.0)
            .clipped()
            .clipShape(Path(starPath()))
            .overlay(Path(starPath()).stroke(Color.white, lineWidth: 4))
            .shadow(color: Color.gray, radius: 5, x: 2, y: 2)
    }
    
    func starPath() -> CGMutablePath {
        let starPath = CGMutablePath()
        starPath.move(to: CGPoint(x: 90, y: 0))
        starPath.addLine(to: CGPoint(x: 121.74, y: 46.31))
        starPath.addLine(to: CGPoint(x: 175.6, y: 62.19))
        starPath.addLine(to: CGPoint(x: 141.36, y: 106.69))
        starPath.addLine(to: CGPoint(x: 142.9, y: 162.81))
        starPath.addLine(to: CGPoint(x: 90, y: 144))
        starPath.addLine(to: CGPoint(x: 37.1, y: 162.81))
        starPath.addLine(to: CGPoint(x: 38.64, y: 106.69))
        starPath.addLine(to: CGPoint(x: 4.4, y: 62.19))
        starPath.addLine(to: CGPoint(x: 58.26, y: 46.31))
        starPath.closeSubpath()
        return starPath
    }
}
