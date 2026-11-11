import Foundation

extension Event {
    static var sampleEvent: Event {
        let json = """
        {
            "text": "1504 – Christopher Columbus uses his knowledge of a lunar eclipse that night to convince Jamaican natives to provide him with supplies.",
            "links": [
                {
                    "text": "1504",
                    "url": "https://en.wikipedia.org/wiki/1504"
                },
                {
                    "text": "Christopher Columbus",
                    "url": "https://en.wikipedia.org/wiki/Christopher_Columbus"
                }
            ]
        }
        """.data(using: .utf8)!
        
        // Decode the single dictionary into a single Event
        return try! JSONDecoder().decode(Event.self, from: json)
    }
}
