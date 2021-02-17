import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "NotificationCenter") {
    let center = NotificationCenter.default
    let myNotifiaction = Notification.Name("MyNotification")
    
    // center subcribes to a publisher
    let publisher = center.publisher(for: myNotifiaction, object: nil)
    
    // subcriber request and receives value from publisher
    let subscription = publisher
        .print()
        .sink { _ in
        print("Notication received from a publisher")
    }
        center.post(name: myNotifiaction, object: nil)
        subscription.cancel()
}

example(of: "Just") {
    let just = Just("Hello World")

    just
        .sink {
            print("Received Completion", $0)
        } receiveValue: {
            print("Received Value", $0)
        }

}

example(of: "assign(to:on)") {
    class SomeObject {
        var value: String = " " {
            didSet {
                print(value)
            }
        }
    }
        let object = SomeObject()

        ["Hello", "World!"].publisher
            .assign(to: \.value, on: object)
            .store(in: &subscriptions)
}

example(of: "PassthroughSubject") {
    let subject = PassthroughSubject<String, Never>()

    subject
        .sink(receiveValue: {print($0)})
        .store(in: &subscriptions)

    subject.send("Hello")
    subject.send("World")
    subject.send(completion: .finished)
    subject.send("Still there?")
}

example(of: "CurrentValueSubject") {
    let subject = CurrentValueSubject<Int, Never>(0)

    subject
        .print()
        .sink(receiveValue: {print($0)})
        .store(in: &subscriptions)

    print(subject.value)

    subject.send(1)
    subject.send(2)

    print(subject.value)

    subject.send(completion: .finished)

}

example(of: "Type erasure") {
    let subject = PassthroughSubject<Int, Never>()

    let publisher = subject.eraseToAnyPublisher()


    publisher
        .sink(receiveValue: {print($0)})
        .store(in: &subscriptions)

    subject.send(0)
}

/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
