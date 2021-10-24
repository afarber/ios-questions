import Combine
import UIKit

/*
var cancellables = Set<AnyCancellable>()

let notificationCenter = NotificationCenter.default
let notificationName = UIResponder.keyboardWillShowNotification
let publisher = notificationCenter.publisher(for: notificationName)

publisher
    .sink(receiveValue: { notification in
        print(notification)
    }).store(in: &cancellables)

notificationCenter.post(Notification(name: notificationName))
 
// name = UIKeyboardWillShowNotification, object = nil, userInfo = nil

*/

var cancellables = Set<AnyCancellable>()

let notificationSubject = PassthroughSubject<Notification, Never>()
let notificationName = UIResponder.keyboardWillShowNotification
let notificationCenter = NotificationCenter.default

notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
    notificationSubject.send(notification)
}

notificationSubject
    .sink(receiveValue: { notification in
        print(notification)
    }).store(in: &cancellables)

notificationCenter.post(Notification(name: notificationName))
