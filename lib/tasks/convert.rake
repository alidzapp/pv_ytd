namespace :convert do
  desc "youtube"
  task :youtube => :environment do
    load "#{Rails.root}/lib/yt_converter.rb"
    YT_Converter.new(ENV['url']).convert
  end
end
