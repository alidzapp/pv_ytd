class ConvertJob
  attr_accessor :convertion_id
  
  def initialize(id)
    self.convertion_id = id
  end

  def process()
    convertion_model = Convertion.find(self.convertion_id)
    load "#{Rails.root}/lib/yt_converter.rb"

    converter = YT_Converter.new(convertion_model.url)
    converter.save_dir = Figaro.env.tmp_storage
    result = converter.convert
    
    if result
      convertion_model.encoding_status = 1
      convertion_model.encoded_file = File.new(result)
      convertion_model.save

      download_urls = ViddlRb.get_names(convertion_model.url)
      convertion_model.title = download_urls.first
      convertion_model.save


      begin
        Pusher.trigger_async('convertion_messages', 'finished', {:token => convertion_model.token})
      rescue Pusher::Error => e
        puts e.message
      end
    end
  end
end