Pod::Spec.new do |s|
  # 框架的名称
  s.name         = "BRKit"
  # 框架的版本号
  s.version      = "0.1.0"
  # 框架的简单介绍
  s.summary      = "A collection of iOS UIKit, Foundation and other extensions."
  # 框架的详细描述(详细介绍，要比简介长)
  s.description  = <<-DESC
                    A collection of iOS UIKit, Foundation and other extensions, Support the Objective - C language.
                DESC
  # 框架的主页
  s.homepage     = "https://github.com/91renb/BRKit"
  # 证书类型
  s.license      = { :type => "MIT", :file => "LICENSE" }

  # 作者
  s.author             = { "任波" => "91renb@gmail.com" }
  # 社交网址
  s.social_media_url = 'https://blog.91renb.com'
  
  # 框架支持的平台和版本
  s.platform     = :ios, "8.0"

  # GitHib下载地址和版本
  s.source       = { :git => "https://github.com/91renb/BRKit.git", :tag => s.version.to_s }

  # 本地框架源文件的位置
  s.source_files  = "BRKit/**/*.{h,m}"
  
  # 框架包含的资源包
  #s.resources  = ""

  # 框架要求ARC环境下使用
  s.requires_arc = true

 
end
