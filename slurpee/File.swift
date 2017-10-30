//  Copyright © 2017 Big Nerd Ranch. All rights reserved.

import Foundation


/// Represents an entity in the file system
/// This could have fun stuff like size, various flavors of checksum, 
/// is it a directory, etc.
struct File {
    /// Where in the filesystem this particular file lives.
    let url: URL
}


extension File: CustomStringConvertible {
    var description: String {
        return "File: \(url)"
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
}
