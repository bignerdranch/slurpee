import Foundation

let fm = FileManager.default
let home = fm.homeDirectoryForCurrentUser

//let dev = URL(string: "file:///dev")!
// `File`s of everything in the home directory
let files = fm.filesInDirectory(at: home)
//let files = fm.filesInDirectory(at: dev)
var totalFileSize: Double = 0

//
// Aggregate file sizes:
//  * "Pictures" has 300 megs
//  * "Cat Pictures" has 700 megs
//  * "Projects" has 30 megs
 
//  * an attribute on "File" - "hey, your'e a directory, how big are you?"
//    - Pro: easy to understand
//    - Con: can be expensive - will we be re-doing work?
//  * or, an external data structure that knows the directory hierarchy and calculates it.
//    - Pro: get to play with more complex stuff
//    - Would havinging the hiererchy handy be useful for other things?
//    - Con: more complex



for file in files {
    if file.fileType == .directory {
        print("Looking at \(file.url.lastPathComponent)...")
        let size = fm.totalSizeOfDirectory(at: file.url)
        print("    \(file.url.lastPathComponent) TOTAL size is \(size)")
    }
    print("\(file)")
}






