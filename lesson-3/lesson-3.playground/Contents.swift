import Foundation
import Combine

extension Character {
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}


extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}



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
    .sink { print("p1 \($0)") }
    .store(in: &subscriptions)



let publisher2 = PassthroughSubject<String, Never>()

publisher2
    .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
    .map({ $0.isSingleEmoji ? $0 : ""
    })
    .sink { print("p2 \($0)") }
    .store(in: &subscriptions)

publisher
    .merge(with: publisher2)
    .sink { print("p3 \($0)") }
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

publisher2.send("a2")
publisher2.send("b2")
publisher2.send("c2")
publisher2.send("🐱")

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    publisher2.send("a3")
    publisher2.send("b3")
    publisher2.send("c3")
    publisher2.send("d3")
}
