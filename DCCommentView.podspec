Pod::Spec.new do |s|
  s.name         = "DCCommentView"
  s.version      = "0.0.4"
  s.summary      = "Comment view for iOS, same as messages app. Customizable."
  s.homepage     = "https://github.com/daltoniam/DCCommentView"
  s.license      = 'Apache License, Version 2.0'
  s.author       = { "Dalton Cherry" => "daltoniam@gmail.com" }
  s.social_media_url = 'http://twitter.com/daltoniam'
  s.source       = { :git => "https://github.com/daltoniam/DCCommentView.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '7.0'
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end
