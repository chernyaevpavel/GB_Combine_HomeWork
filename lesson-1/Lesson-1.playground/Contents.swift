import Foundation
import Combine

let publisherNames = ["Alex", "Bob", "Agata"].publisher

let subscription = publisherNames.sink { name in
    print("Hello \(name)!")
}

publisherNames
    .filter({$0.count > 3})
    .sink(receiveValue: { print($0) })



let myNitification = Notification.Name("PublisherNotification")

let publisher = NotificationCenter.default.publisher(for: myNitification)

let subs = publisher.sink { _ in
    print("Notification")
}

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    NotificationCenter.default.post(name: myNitification, object: nil)
}





