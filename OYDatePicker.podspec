#
# Be sure to run `pod lib lint PodDemo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OYDatePicker'
  s.version          = '1.0.0'
  s.summary          = '日期选择控件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  一个日期选择控件，支持农历和公历切换。
                       DESC

  s.homepage         = 'https://github.com/ohyeahhh/PodDemo'
  s.license          = { :type => 'MIT' }
  s.author           = { 'ohyeahhh' => 'ohyeahmisoh@gmail.com' }
  s.source           = { :git => 'https://github.com/ohyeahhh/OYDatePicker.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = ['OYDatePicker/**/*.{m,h}']
  s.public_header_files = ['OYDatePicker/*.h']
  s.dependency  'Masonry'
  s.requires_arc = true
 
end
