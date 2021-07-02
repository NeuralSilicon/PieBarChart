Pod::Spec.new do |spec|

  spec.name         = "PieBarChart"
  spec.version      = "0.0.1"
  spec.summary      = "Chart CocoaPods library written in Swift"

  spec.description  = <<-DESC
This library gives you two separate charts; Bar chart, and Pie chart. Or both could be used.
                   DESC

  spec.homepage     = "https://github.com/NeuralSilicon/PieBarChart"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Ian Cooper" => "Neuralsilicon@gmail.com" }


  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5"

  spec.source       = { :git => "https://github.com/NeuralSilicon/PieBarChart.git", :tag => "#{spec.version}" }
  spec.source_files  = "PieBarChart/**/*.{h,m,swift}"


end
