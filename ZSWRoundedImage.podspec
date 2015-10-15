Pod::Spec.new do |s|
  s.name             = "ZSWRoundedImage"
  s.version          = "1.0"
  s.summary          = "A short description of ZSWRoundedImage."
  s.description      = <<-DESC
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
