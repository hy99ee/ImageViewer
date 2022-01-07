//
//  ImageSetupTimerLabel.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 28.12.2021.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class ImageSetupTimer {

    private var _isError = false
    var isError:Bool{
        set{
            _isError = newValue
            if newValue {
                self.timerCount.accept(timeCountError)
            }
        }
        get{
            _isError
        }
    }
    var timerCount = BehaviorRelay(value: Int())
    private let timeCountDefault:Int
    private let timeCountError = 5
    private var timer = Timer()
    init(timeCount:Int) {
        self.timeCountDefault = timeCount
        createTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _timer in

            if self.timerCount.value > 0{
                self.timerCount.accept(self.timerCount.value - 1)
            }
            else{
                self.timerCount.accept(self.isError ? self.timeCountError : self.timeCountDefault)
            }
        }
    }

}
 
