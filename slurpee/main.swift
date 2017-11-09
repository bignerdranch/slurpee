import Foundation

let fm = FileManager.default
let home = fm.homeDirectoryForCurrentUser

let dev = URL(string: "file:///dev")!
// `File`s of everything in the home directory
//let files = fm.filesInDirectory(at: home)
let files = fm.filesInDirectory(at: dev)
var totalFileSize: Double = 0


for file in files {
    print("\(file)")
}

