//
//  ViewController.swift
//  Swift_Combine_with_Alamofire
//
//  Created by admin on 2019/07/25.
//  Copyright © 2019 h.crane. All rights reserved.
//

import UIKit
import Combine
import Alamofire

class ViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = UserRequest()
        
        NetworkPublisher.publish(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: print("finished")
                case .failure(let e): print("failure", e)
                }
            }, receiveValue: { value in
                print("receiveValue", value.data)
            }).store(in: &cancellables)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
