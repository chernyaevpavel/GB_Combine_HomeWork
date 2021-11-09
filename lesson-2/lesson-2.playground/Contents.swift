import Combine

//Задание 1
var publisher = (1...100).publisher

print("method 1")
publisher
    .filter( {$0 > 50 && $0 < 71 && $0 % 2 == 0} )
    .sink {
        print($0)
    }

print("method 2")
publisher
    .dropFirst(50)
    .prefix(20)
    .filter({ val in
        val % 2 == 0
    })
    .collect()
    .sink { print($0) }


//Задание 2
var publisherStr = ["Привет", "Вячеслав", "меня", "зовут", "Павел"].publisher

publisherStr
    .map { Double($0.count) }
    .collect()
    .map { $0.reduce(0.0, +) / Double($0.count) }
    .sink { print($0) }
