//
//  ImageSetupTimerLabel.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 28.12.2021.
//

import Foundation
import UIKit

final class ImageSetupTimerLabel: UILabel {

    private var _isError = false
    var isError:Bool{
        set{
            _isError = newValue
            if newValue {
                self.isHidden = true
                timeCount = timeCountError
            }
            else{
                self.isHidden = false
            }
        }
        get{
            _isError
        }
    }
    private var timeCount:Int
    private let timeCountDefault:Int
    private let timeCountError = 5
    private var timer = Timer()
    private let complition:() -> Void
    init(timeCount:Int, complition: @escaping () -> Void ) {
        self.complition = complition
        self.timeCountDefault = timeCount
        self.timeCount = timeCountDefault
        super.init(frame: UIScreen.main.bounds)
        font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        self.complition()
        createTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _timer in
            self.text = String(self.timeCount)
            if self.timeCount > 0{
                self.timeCount -= 1
            }
            else{
                self.timeCount = self.isError ? self.timeCountError : self.timeCountDefault
                self.text = ""
                self.complition()
            }
        }
    }

}
 
