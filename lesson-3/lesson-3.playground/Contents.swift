import UIKit
import Combine


var subscriptions = Set<AnyCancellable>()

let publisher = PassthroughSubject<String, Never>()

publisher
    .collect(.byTime(DispatchQueue.main, 0.5))
    .map({ arr -> String in
        let arr2 = arr.map { val -> String? in
            guard let unicodeScalar = UnicodeScalar(val) else { return nil }
            let char = Character(unicodeScalar)
            return String(char)
        }
        let resultStr = arr2.reduce("") { accum, next in
            guard let str = next else { return accum }
            return accum + str
        }
        return resultStr
    })
    .sink { print($0) }
    .store(in: &subscriptions)

publisher.send("A")
publisher.send("B")
publisher.send("C")
publisher.send("D")

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    publisher.send("a")
    publisher.send("b")
    publisher.send("c")
    publisher.send("d")

}
