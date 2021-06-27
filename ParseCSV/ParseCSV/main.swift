//
//  main.swift
//  ParseCSV
//
//  Created by Alexander Farber on 27.06.21.
//

import Foundation

func process(string: String) throws {
    print("your code here")
}

func processFile(at url: URL) throws {
    let s = try String(contentsOf: url)
    try process(string: s)
}

func main() {
    guard CommandLine.arguments.count > 1 else {
        print("usage: \(CommandLine.arguments[0]) file...")
        return
    }
    for path in CommandLine.arguments[1...] {
        do {
            let u = URL(fileURLWithPath: path)
            try processFile(at: u)
        } catch {
            print("error processing: \(path): \(error)")
        }
    }
}

main()
exit(EXIT_SUCCESS)
