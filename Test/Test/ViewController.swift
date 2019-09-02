//
//  ViewController.swift
//  Example
//
//  Created by Ammar Altahhan on 02/09/2019.
//  Copyright © 2019 Ammar Altahhan. All rights reserved.
//

import UIKit
import TransitionalLoader

class ViewController: UIViewController {
    
    let ui = ControllerView()
    
    override func loadView() {
        view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ui.didTapView = { view in
            if view.tag == 1 {
                view.startLoader()
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    view.stopLoader(finishState: .success(restoreView: true, inGreen: true))
                })
            } else if view.tag == 2 {
                view.startLoader(onTapWhileLoading: .error(restoreView: true))
            } else if view.tag == 3 {
                view.startLoader(onTapWhileLoading: .success(restoreView: false, inGreen: false))
            } else if view.tag == 4 {
                view.startLoader(onTapWhileLoading: .cancel)
            }
        }
    }
}

