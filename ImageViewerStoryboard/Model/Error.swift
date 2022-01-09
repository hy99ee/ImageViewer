//
//  Error.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 09.01.2022.
//
struct ImageError: Error {
    private let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
