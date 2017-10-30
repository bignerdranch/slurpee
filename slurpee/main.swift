import Foundation

print("Hello, World!")

let fm = FileManager.default
let currentWorkingDirectory = fm.currentDirectoryPath // The Build/Products/Debug directory
print("HOME: \(currentWorkingDirectory)")

// get the top-level as URLs
let filePaths = try! fm.contentsOfDirectory(atPath: currentWorkingDirectory)
print("\(filePaths)")

for path in filePaths {
    var isDirectory: ObjCBool = false
    _ = fm.fileExists(atPath: path, isDirectory: &isDirectory)

    print("\(path) is directory \(isDirectory)")
}
