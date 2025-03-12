//
//  ImageGenerationStep.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import SwiftUI

enum ImageGenerationStep: Equatable {
    case initializing
    case generatingImageGrid
    case pathFinding
    case generatingImage
    case complete
    case errored(error: LocalizedStringKey)
    
    var label: LocalizedStringKey {
        switch self {
        case .initializing:
            return "initializing"
        case .generatingImageGrid:
            return "generating_image_grid"
        case .pathFinding:
            return "path_finding"
        case .generatingImage:
            return "generating_image"
        case .complete:
            return "complete"
        case .errored(error: let error):
            return error
        }
    }
    
    var isError: Bool {
        switch self {
        case .errored:
            return true
        default:
            return false
        }
    }
}
