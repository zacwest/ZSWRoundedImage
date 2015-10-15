Pod::Spec.new do |s|
  s.name             = "ZSWRoundedImage"
  s.version          = "1.0"
  s.summary          = "Creates rounded-rectangle UIImages."
  s.description      = <<-DESC
                       This extension to UIImage creates images with any of the corners
                       rounded, optionally with a border and color.
                       DESC
  s.homepage         = "https://github.com/zacwest/ZSWRoundedImage"
  s.license          = 'MIT'
  s.author           = { "Zachary West" => "zacwest@gmail.com" }
  s.source           = { :git => "https://github.com/zacwest/ZSWRoundedImage.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zacwest'

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'ZSWRoundedImage/**/*'
  s.frameworks = 'UIKit'
end
