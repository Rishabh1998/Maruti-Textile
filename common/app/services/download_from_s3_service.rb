class DownloadFromS3Service

  attr_reader :bucket_url, :location

  def initialize(bucket_url, file_name = 'data')
    @bucket_url = bucket_url
    @file_name = file_name
    @location = get_temp_file_location
    save_to_local_temp
  end

  def remove
    FileUtils.rm(location) if File.exist?(location)
  end

  private
    def save_to_local_temp
      begin
        File.open(location, 'wb') do |file|
          open(bucket_url) { |net| file.write(net.read) }
        end
      rescue OpenURI::HTTPError
        raise "could not open file"
      end
    end

    def get_temp_file_location
      File.join('/tmp', "#{@file_name}_#{Time.current.to_i}")
    end
end 