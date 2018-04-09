
Pod::Spec.new do |s|
s.name         = "GMToolBarInputView"
s.version      = "0.0.2"
s.ios.deployment_target = '8.0'
s.summary      = "评论"
s.homepage     = "https://github.com/GImperialSeal/Inputbar"
s.license      = "MIT"
s.author       = { "gyx" => "18637780521@163.com" }
s.source       = { :git => 'https://github.com/GImperialSeal/Inputbar.git',:tag => s.version}
s.requires_arc = true
s.source_files = 'GMToolBarInputView/InputBar/*'
end
