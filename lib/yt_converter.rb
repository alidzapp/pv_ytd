require 'pty'
class YT_Converter
  attr_accessor :source_url, :audio_file, :save_dir

  def initialize(url)
    self.source_url = url
  end

  def convert
    cmd = "viddl-rb -e"
    if self.save_dir
      cmd << "-s #{self.save_dir}"
    end

    cmd << " #{self.source_url}"

    puts cmd

    begin
      PTY.spawn( cmd ) do |stdin, stdout, pid|
        begin
          # Do stuff with the output here. Just printing to show it works
          stdin.each do |line|
            print line
            if ( line =~ /Done extracting audio to(.*)/ )
              self.audio_file = line.gsub("Done extracting audio to","").strip
              puts "audio file: <#{self.audio_file}>"
            end
          end
        rescue Errno::EIO
          puts "Errno:EIO error, but this probably just means " +
          "that the process has finished giving output"
        end
      end
      rescue PTY::ChildExited
        puts "The child process exited!"
      end

      if self.audio_file && File.exists?(self.audio_file)
        puts "audio file exists"
        return self.audio_file
      end
      return false
  end # end of convert
end