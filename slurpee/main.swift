/* How to discover

File struct:
  - url
  - size
  - File System Type (file, directory, etc)
  - (any other metadata we want)

how to tell if things are different. How things are different
(ordered from most efficient to least)

- file size

- file content checksum of a subset
  - first K, last K, then couple of K in the middle.
  - Can do by seeking and reading 1K buffers and comparing
  
- file content checksum of entire contents
  - CRC, MD5, or just sum up all the bytes, or something
  - Can do by either using an existing MD5/CRC algorithm, or
  - shell-out to `md5sum` or `sum


--- is there a fast way to get a file type
  - mp3 vs jpeg vs MSWord document
  - shell-out to `file`
  - or adapt the Darwin implementation of `file` (which is old-style tense C code)
  
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
   
Map/Reduce?

Resource load
  - do it in parallel as we walk the file system
    - for each file, toss on to a producer/consumer queue for checksumming, or something
    - which can do a bunch at once
    - and then some data structure that boils down.
  - Reading files (or chunks of files) into memory to process, perhaps
    - reading a 70 gigabyte file will give us a bad day
    - need read by chunks, or use memory-mapped file
  - or a bunch of fork/exec calls
  - Reading portions of files and processing them
  - One File structure per entity in the file system (millions)

Lazy collections?
  - "lazy tuple" - (file size, segmented checksum, file type, total checksum)
  -  FileA and FileB - hey, are file sizes the same?  If so, then check the segmented checksum
  
- and also keep running total.
- throw in a hash map data structure.  Check to see in there.

* Hash[Size] - look up via File.size
  * Files, or segmented checksums
    * full checksum.
    
let hash = DuplicateHashCollectionBidirectionalInsanity()

for file in theWorld {
    existingThing = hash[file.size]
    if not - first guy we've seen with this size {
        hash[file.size] = file
    } else if we do, we've seen others {
        hash[file.size = [existing file 1, existing file 2, file]
    }
}
  
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





