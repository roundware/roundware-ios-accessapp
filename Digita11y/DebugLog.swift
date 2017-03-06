//
//  DebugLog.swift
//  Digita11y
//
// http://stackoverflow.com/a/35577666/1638909

import Foundation
import Crashlytics
func DebugLog(_ message: String,
              file: StaticString = #file,
              function: StaticString = #function,
              line: Int = #line)
{
    let output: String
    if let filename = URL(string:String(describing: file))?.lastPathComponent.components(separatedBy: ".").first
    {
        output = "\(filename).\(function) line \(line) $ \(message)"
    }
    else
    {
        output = "\(file).\(function) line \(line) $ \(message)"
    }

    #if DEBUG
        CLSNSLogv("%@", getVaList([output]))
    #else
        CLSLogv("%@", getVaList([output]))
    #endif
}
