Pod::Spec.new do |s|

  s.name         = "JTComponentKit"
  s.version      = "1.0.5"
  s.summary      = "A modular framework for abstracting sections of UICollectionView into individual components, enabling better decoupling and reusability in iOS applications."

  s.description  = <<-DESC
                    This framework abstracts each section of a UICollectionView into distinct components, 
                    with each component responsible for implementing UICollectionView delegate methods. 
                    This design allows for cleaner separation of concerns by dividing the collection view into independent, 
                    reusable modules. By isolating the logic of each section, 
                    it simplifies the maintenance of complex layouts and facilitates better reuse of UI components 
                    across different screens. Additionally, this approach encourages scalability 
                    and enhances the testability of each section individually, 
                    fostering a more flexible and modular UI development process.
                   DESC

  s.homepage     = "https://github.com/xhjcs/JTComponentKit.git"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "xinghanjie" => "xinghanjie@gmail.com" }

  s.ios.deployment_target = "11.0"
  s.ios.frameworks = 'Foundation', 'UIKit'


  s.source       = { :git => "https://github.com/xhjcs/JTComponentKit.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/#{s.name}/**/*"
  s.private_header_files = "Sources/#{s.name}/**/*_Private.h",
                            "JTComponentCell.h",
                            "JTComponentReusableView.h"

  s.swift_version = '5.0'

  s.requires_arc = true

end
