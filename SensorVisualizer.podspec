Pod::Spec.new do |s|
  s.name             = "SensorVisualizer"
  s.version          = "0.1.0"
  s.summary          = "Visualize Sensors On iOS Devices"

  s.description      = <<-DESC
  Visualize sensors such as single taps, multiple taps, long presses,
  pan gestures, 3D touches, power charging, WiFi connetivity, Bluetooth
  connectivity, GPS, notifications, vibrations, and phone shaking
  DESC

  s.homepage         = "https://github.com/design-utilities/sensor-visualizer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Joe Blau" => "josephblau@gmail.com" }
  s.source           = { :git => "https://github.com/design-utilities/sensor-visualizer.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/joe_blau'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'UIKit'
end
