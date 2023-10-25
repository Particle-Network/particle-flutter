#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint particle_wallet.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'particle_wallet'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin project for particle wallet'
  s.description      = <<-DESC
A flutter plugin project for particle wallet
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  s.swift_version = '5.7'

  s.dependency 'ParticleWalletGUI'
end
