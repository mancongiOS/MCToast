#
# Be sure to run `pod lib lint MCToast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MCToast'
  s.version          = '0.1.0'
  s.summary          = 'Swift版本的HUD，支持多种自定义方案。使用方便。'
  s.homepage         = 'https://github.com/mancongiOS/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MC' => '562863544@qq.com' }
 
  s.source           = { :git => 'https://github.com/mancongiOS/MCToast.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
 
  s.swift_version = '5.0'
  
  s.source_files = 'MCToast/Classes/**/*'
  
   s.resource_bundles = {
     'ToastBundle' => ['MCToast/Assets/**/*']
   }

   s.dependency 'lottie-ios'

end
