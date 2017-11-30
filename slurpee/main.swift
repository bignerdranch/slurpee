/* How to discover

how to tell if things are different. How things are different
(ordered from most efficient to least)

File struct:
  - size
  - url
  - (any other metadat we want)

- file size

- file content checksum of a subset
  - first K, last K, then couple of K in the middle.
  
- file content checksum of entire contents
   CRC, MD5, or just sum up all the bytes, or something


--- is there a fast way to get a file type
  - mp3 vs jpeg vs MSWord document
- a way of disambiguating files


NSDocument?  Has a duplicat-detection method? (maybe related to icloud)


partition the Files in groups of similar files - "Dupe collection"
  - group same-y things
  - gonna be a lot of them
  
Equivalence Classes?
  - partitionng the set of Files into groups of "the same file"
  - ulimately, get a "hey, here's all the kind-of files"

flatmap
   - removes nils
   - "hoists" collections
   [[[a, b, nil, c], [d, e]]][f, nil, g]
   [a, b, c, d, e, f, g]

*/


import Foundation
import Darwin

let fm = FileManager.default
let home = fm.homeDirectoryForCurrentUser

//let dev = URL(string: "file:///dev")!
// `File`s of everything in the home directory
// let downloads = home.appendingPathComponent("Projects").appendingPathComponent("swift").appendingPathComponent("swift")
// let downloads = home.appendingPathComponent("Projects")
let downloads = home


//let files = fm.filesInDirectory(at: dev)

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


let startTime = mach_absolute_time()

let files = fm.filesInDirectory(at: downloads)
var totalFileSize: Int = 0

for file in files {
    if file.fileType == .directory {
        print("Looking at \(file.url.lastPathComponent)...")
        let size = fm.totalSizeOfDirectory(at: file.url)
//        let size = fm.totalSizeOfDirectoryWithDeepRecursion(at: file.url)
        totalFileSize += size
        print("processed \(file) : \(size)")
    }
}

let stopTime = mach_absolute_time()

var timebase = mach_timebase_info()
_ = mach_timebase_info(&timebase)

let time = ((stopTime - startTime) * UInt64(timebase.numer)) / UInt64(timebase.denom)
let timeInSeconds = Double(time) / 1_000_000_000

print("total: \(totalFileSize / (1024 * 1024)) and took \(timeInSeconds) seconds")
print("counts: \(sizeCount) and \(typeCount)")





