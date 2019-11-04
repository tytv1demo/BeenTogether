//
//  Logger.swift
//  OhMyMirror
//
//  Created by Lucas Lee on 5/2/18.
//  Copyright © 2018 Lucas Lee. All rights reserved.
//

import Foundation
import XCGLogger

let documentDirectory: NSURL = {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.endIndex - 1] as NSURL
}()

let cachesDirectory: NSURL = {
    let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls[urls.endIndex - 1] as NSURL
}()

// XCGLogger
let log: XCGLogger = {
    let log = XCGLogger.default
    
    if let consoleDestination: FileDestination = log.destination(withIdentifier: XCGLogger.Constants.fileDestinationIdentifier) as? FileDestination {
        let xcodeColorsLogFormatter: XcodeColorsLogFormatter = XcodeColorsLogFormatter()
        xcodeColorsLogFormatter.colorize(level: .verbose, with: XcodeColorsLogFormatter.XcodeColor(red: 240, green: 231, blue: 215), on: XcodeColorsLogFormatter.XcodeColor(red: 0, green: 41, blue: 51))
        xcodeColorsLogFormatter.colorize(level: .debug, with: XcodeColorsLogFormatter.XcodeColor(red: 127, green: 149, blue: 150), on: XcodeColorsLogFormatter.XcodeColor(red: 0, green: 41, blue: 51))
        xcodeColorsLogFormatter.colorize(level: .info, with: XcodeColorsLogFormatter.XcodeColor(red: 0, green: 143, blue: 206), on: XcodeColorsLogFormatter.XcodeColor(red: 0, green: 41, blue: 51))
        xcodeColorsLogFormatter.colorize(level: .warning, with: XcodeColorsLogFormatter.XcodeColor(red: 190, green: 134, blue: 39), on: XcodeColorsLogFormatter.XcodeColor(red: 0, green: 41, blue: 51))
        xcodeColorsLogFormatter.colorize(level: .error, with: XcodeColorsLogFormatter.XcodeColor(red: 219, green: 64, blue: 32), on: XcodeColorsLogFormatter.XcodeColor(red: 0, green: 41, blue: 51))
        xcodeColorsLogFormatter.colorize(level: .severe, with: XcodeColorsLogFormatter.XcodeColor(red: 238, green: 23, blue: 49), on: XcodeColorsLogFormatter.XcodeColor(red: 0, green: 41, blue: 51))
        
        consoleDestination.formatters = [xcodeColorsLogFormatter]
    }
    
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯 ", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹 ", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ ", to: .info)
    emojiLogFormatter.apply(prefix: "⚠️ ", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️ ", to: .error)
    emojiLogFormatter.apply(prefix: "💣 ", to: .severe)
    log.formatters = [emojiLogFormatter]
    
    
    let logPath: NSURL = cachesDirectory.appendingPathComponent("AppLogger.txt")! as NSURL
    
    #if DEBUG
    log.setup(level: .verbose, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath, fileLevel: .debug)
    #else
    log.setup(level: .severe, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath, fileLevel: .severe)
    #endif
    
    return log
}()
