# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'PokemonApps' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Alamofire untuk networking
  pod 'Alamofire'

  # Kingfisher untuk image caching
  pod 'Kingfisher'

  # RxSwift dan RxCocoa untuk reactive programming
  pod 'RxSwift'
  pod 'RxCocoa'

  # MBProgressHUD untuk loading indicator
  pod 'MBProgressHUD', '~> 1.2.0'

  # XLPagerTabStrip untuk tab style pager
  pod 'XLPagerTabStrip'

  # RealmSwift untuk local database
  pod 'RealmSwift'
  pod 'Realm'

  # SQLite.swift alternatif lain jika tidak pakai Realm
  # pod 'SQLite.swift', '~> 0.12.2'
end

# 🔹 Tambahkan ini di luar target
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
