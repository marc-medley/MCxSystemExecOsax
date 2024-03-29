# MCxSystemExecOsax README

## Contents <a id="contents"></a>
[Background](#Background) •
[Resources](#resources-)

`MCxSystemExecOsax` provides a set of Swift wrappers around the Open Scripting Architecture eXtensions (OSAX).  A general run unix script is also included.

## Background <a id="Background"></a><sup>[▴](#contents)</sup>

Apple provides a set of common user interactions (e.g. dialogs and alerts) in the [Open Scripting Architecture eXtensions (OSAX)](https://en.wikipedia.org/wiki/AppleScript#Open_Scripting_Architecture).  Swift can call OSAX routines using `Process()` with the `executableURL` set to "/usr/bin/osascript". 

``` swift
let process = Process()
let url: URL = URL(fileURLWithPath: "/usr/bin/osascript") // :NOTE: future deprecated
//let url: URL = URL(filePath: "/usr/bin/osascript")      // :NOTE: future
process.executableURL = url
process.arguments = args // Applescript
// ... more code here ...
```

_It would be really interesting if a crossplatform user interaction library similar to OSAX existed. For example, such a library could likely be implemented with [Swift + Gnome Toolkit (GTK+)](https://github.com/search?utf8=✓&q=swift+gtk)._ 

## Resources <a id="resources-"></a><sup>[▴](#contents)</sup>

[StackOverflow: How to present a window from an OSX Swift command line tool or shebang script file? ⇗](https://stackoverflow.com/questions/34715691/how-to-present-a-window-from-an-osx-swift-command-line-tool-or-shebang-script-fi?noredirect=1#comment84882697_34715691)
