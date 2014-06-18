Pod::Spec.new do |s|
     s.name         = "TKCircleProgressBtn"
     s.version      = "0.1.0"
     s.summary      = "TKCircleProgressBtn is an UIControl(Btn), it's have progress and two state."
     s.homepage     = "https://github.com/tony7day/TKCircleProgressBtn"
     s.screenshots  = "https://github.com/tony7day/TKCircleProgressBtn/blob/master/screenshot.PNG"
     s.license      = 'MIT (LICENSE)'
     s.author       = { "Hanning Kong" => "hanningkong@gmail.com" }
     s.platform     = :ios, '6.0'
     s.source       = { :git => "https://github.com/tony7day/TKCircleProgressBtn.git", :tag => "0.1.0" }
     s.source_files  = 'TKCircleProgressBtn/*.{h,m}'
     s.framework  = 'QuartzCore'
     s.requires_arc = true
end
