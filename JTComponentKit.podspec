Pod::Spec.new do |s|

  s.name         = "JTComponentKit"
  s.version      = "1.0.0"
  s.summary      = "A lightweight, thread-safe Promise library for Swift and Objective-C, with a JavaScript-like API."

  s.description  = <<-DESC
                    Promise is a lightweight, thread-safe implementation of the Promise pattern in Swift, designed to work seamlessly with both Swift and Objective-C projects. 
                    Its API is fully consistent with JavaScript's Promise, making it intuitive for developers familiar with modern JavaScript asynchronous workflows. 
                    Promise simplifies handling asynchronous operations by supporting easy chaining of tasks, robust error handling, and a clean, manageable syntax. 

                    Using os_unfair_lock for efficient synchronization, this library ensures fast and safe execution in concurrent environments. Whether you're working on 
                    a Swift or Objective-C project, Promise provides a small, flexible, and powerful tool to streamline your asynchronous code.
                   DESC

  s.homepage     = "https://github.com/xhjcs/JTComponentKit.git"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "xinghanjie" => "xinghanjie@gmail.com" }

  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.15"


  s.source       = { :git => "https://github.com/xhjcs/JTComponentKit.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/#{s.name}/**/*"
  s.private_header_files = "Sources/JTComponentKit/Private/*.h"

  s.swift_version = '5.0'

  s.requires_arc = true

end
