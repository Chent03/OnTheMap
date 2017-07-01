//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/19/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
