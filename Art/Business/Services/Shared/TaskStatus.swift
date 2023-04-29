//
//  TaskStatus.swift
//  Art
//
//  Created by Sander de Koning on 29/04/2023.
//

import Foundation

enum TaskStatus<R: Sendable> {
    case inProgress(Task<R, Error>)
    case finished(R)
}
