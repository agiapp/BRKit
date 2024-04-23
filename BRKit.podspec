Pod::Spec.new do |s|
  # 框架的名称
  s.name         = "BRKit"
  # 框架的版本号
  s.version      = "2.1.1"
  # 框架的简单介绍
  s.summary      = "A collection of iOS UIKit, Foundation and other extensions."
  # 框架的详细描述(详细介绍，要比简介长)
  s.description  = <<-DESC
                    A collection of iOS UIKit, Foundation and other extensions, Support the Objective - C language.
                DESC
  # 框架的主页
  s.homepage     = "https://github.com/agiapp/BRKit"
  # 证书类型
  s.license      = { :type => "MIT", :file => "LICENSE" }

  # 作者
  s.author             = { "任波" => "developer@irenb.com" }
  # 社交网址
  s.social_media_url = 'https://www.irenb.com'
  
  # 框架支持的平台和版本
  s.platform     = :ios, "9.0"

  # GitHib下载地址和版本
  s.source       = { :git => "https://github.com/agiapp/BRKit.git", :tag => s.version.to_s }

  s.public_header_files = 'BRKit/BRKit.h'

  # 本地框架源文件的位置
  # s.source_files  = "BRKit/**/*.{h,m}"
  # 一级目录（pod库中根目录所含文件）
  s.source_files  = "BRKit/BRKit.h"
  
  # 二级目录（根目录是s，使用s.subspec设置子目录，这里设置子目录为ss）
  s.subspec 'Foundation' do |ss|
    ss.source_files = 'BRKit/Foundation/*.{h,m}'
  end
  
  s.subspec 'UIKit' do |ss|
    ss.dependency 'BRKit/Foundation'
    ss.source_files = 'BRKit/UIKit/*.{h,m}'
  end
  
  # 框架包含的资源包
  # s.resources  = ""
  # 隐私清单
  s.resource_bundles = { 'BRKit.Privacy' => 'BRKit/PrivacyInfo.xcprivacy' }

  # 框架要求ARC环境下使用
  s.requires_arc = true

end
