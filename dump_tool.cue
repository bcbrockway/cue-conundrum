package main

import (
    "strings"
    "tool/cli"
    "tool/file"
    "encoding/yaml"
)

args: {
  // Read the comma-separated list of files from `cue cmd dump --inject files=/path/to/file1,/path/to/file2` into the
  // args.files var.
  files: string @tag("files")
}

objects: [for v in objectSets for x in v {x}]

objectSets: [
  fooBarCombined,
  foo,
  bar,
]

command: {
  dump: {
    // Split the comma-separated list of files into a list of strings ([...string])
    files: strings.Split(args.files, ",")

    // Create some tasks called f1, f2, f3 and so on - one for each file inputted - that read their respective file's
    // contents and then merge them together into a "merged" variable.
    for i, filepath in files {
      "f\(i)": {
        // Ensure the tasks are run from left to right sequentially so that we know which one contains the final merged
        // contents (i.e. the last one listed on the command line).
        if i > 0 {
          $dep: command.dump["f\(i-1)"].merged
        }
        // Read the contents of the file.
        read: file.Read & {
          filename: filepath
          contents: string
        }
        // If it's the first file in the list, create a variable with just its contents.
        if i == 0 {
          merged: yaml.Unmarshal(read.contents)
        }
        // If it's a subsequent file, merge its contents with the "merged" var from the previous task.
        if i > 0 {
          merged: command.dump["f\(i-1)"].merged & yaml.Unmarshal(read.contents)
        }
      }
    }

    config: command.dump["f\(len(files)-1)"].merged
    
    printConfig: cli.Print & {
      text: yaml.Marshal(config)
    }
    
    printObjects: cli.Print & {
      text: yaml.MarshalStream(objects)
    }
  }

}

config: command.dump.config
