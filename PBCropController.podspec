Pod::Spec.new do |spec|

  spec.name         = "PBCropController"
  spec.version      = "0.0.1"
  spec.summary      = "A simple image cropper library"

  spec.homepage     = "https://github.com/Ankitkarna/PBCropController"

    spec.license      = { :type => "MIT", :file => "LICENSE" }


  spec.author             = { "Ankit" => "ankit.karna2011@gmail.com" }

    spec.platform     = :ios, "11.0"


  spec.source       = { :git => "https://github.com/Ankitkarna/PBCropController.git", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  spec.source_files  = "PBCropController/Source"
  spec.swift_version = "5.0"
  

end
