//
//  CMTime + Ext.swift
//  Music Player
//
//  Created by Saidaxmad on 01/10/22.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totlantSecond = Int(CMTimeGetSeconds(self))
        let second = totlantSecond % 60
        let minutes = totlantSecond / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, second)
        return timeFormatString
    }
}
