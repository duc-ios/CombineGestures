//
//  ViewController.swift
//  CombineGestures
//
//  Created by Duc iOS on 07/22/2021.
//  Copyright (c) 2021 Duc iOS. All rights reserved.
//

import UIKit
import CombineNSObject
import CombineGestures

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tap().sink { gestureType in
            print("Tap !")
        }.store(in: &cancellables)
        view.pan().sink { gestureType in
            print("Pan !")
        }.store(in: &cancellables)
        view.pinch().when( .recognized).sink { gestureType in
            print("Pinch !")
        }.store(in: &cancellables)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

