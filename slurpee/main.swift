import Foundation

let fm = FileManager.default
let home = fm.homeDirectoryForCurrentUser

// `File`s of everything in the home directory
let files = fm.filesInDirectory(at: home)

for file in files {
    print("\(file)")
}

