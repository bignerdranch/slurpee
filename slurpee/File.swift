//  Copyright © 2017 Big Nerd Ranch. All rights reserved.

import Foundation

enum FileType {
    case file
    case directory
    case symbolicLink
    case device
    case unknown

    init(type: String) {
        switch FileAttributeType(rawValue: type) {
        case .typeRegular:
            self = .file
        case .typeDirectory:
            self = .directory
        case .typeSymbolicLink:
            self = .symbolicLink
        case .typeBlockSpecial,
             .typeCharacterSpecial:
            self = .device
        default:
            self = .unknown
        }
    }
}


/// Represents an entity in the file system
/// This could have fun stuff like size, various flavors of checksum, 
/// is it a directory, etc.
struct File {
    /// Where in the filesystem this particular file lives.
    let url: URL

    var fileSize: Int? {
        return try? FileManager.default.attributesOfItem(atPath: url.path)[FileAttributeKey.size] as? Int ?? 0
    }

    var fileType: FileType {
        let type = ((try? FileManager.default.attributesOfItem(atPath: url.path)[FileAttributeKey.type] as? String) ?? "") ?? ""
        return FileType(type: type)
    }

    init(url: URL) {
        self.url = url
    }
}


extension File: CustomStringConvertible {
    var description: String {
        return "File: \(url) file size = \(fileSize!)  type = \(fileType)"
    }
}

extension FileManager {

    /// Fetch (non-recursively) the contents of the directory and return
    /// Files for each entity there.
    func filesInDirectory(at url: URL) -> [File] {
        do {
            let urls = try self.contentsOfDirectory(at: url,
                                                    includingPropertiesForKeys: nil,
                                                    options: [])
            let files = urls.map(File.init(url:))
            return files

        } catch {
            print("Could not read files at url \(url)")
            return []
        }
    }
    
    // total size of directory, deep
    func totalSizeOfDirectory(at url: URL) -> Int {
        let files = self.filesInDirectory(at: url)
        var size = 0

        for file in files {
            if file.fileType == .directory {
                size += totalSizeOfDirectory(at: file.url)
            } else {
                size += file.fileSize ?? 0
            }
        }
        
        return size
    }
    
    // total size for a flat directory
    func sizeOfDirectory(at url: URL) -> Int {
        let files = self.filesInDirectory(at: url)
        
        
        let size = files.reduce(0, { accumulator, file in accumulator + (file.fileSize ?? 0) })
        print("size! \(size)")
        return size
    }
}





