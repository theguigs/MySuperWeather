//
//  Debouncer.swift
//  Engine
//
//  Created by Guillaume Audinet on 12/03/2023.
//

import Foundation

public class Debouncer {
    private var debounceTimer: Timer?
    
    public init() { }
    
    public func debounce(time: Double = 0.2, completion: @escaping () -> Void) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
            completion()
        }
    }
}
