//
//  GuaranteeMainThread.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 16/01/2021.
//

import Foundation

func guaranteeMainThread(_ work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}
