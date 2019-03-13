class UploadToS3Service

  attr_reader :client, :file, :file_name, :bucket, :public_url, :upload_folder

  def initialize(file, file_name, options = {})
    @client = set_client
    @file = file
    @extension = options[:extension] || "csv"
    @file_name = file_name
    @public_read = options[:public_read] || false
    @bucket = GlobalConstant::S3['bucket']
    @upload_folder = options[:upload_folder]
  end

  def upload_file
    obj = client.bucket(bucket).object(get_file_location)
    obj.put(body: file, acl: acl_value, content_disposition: 'attachment')
    @public_url = obj.public_url
  end

  def update_file
    obj = client.bucket(bucket).object(get_file_location)
    obj.delete
    sleep 1
    obj.put(body: file, acl: acl_value, content_disposition: 'attachment')
  end

  private
    def set_client
      Aws.config.update({
        region: GlobalConstant::S3['region'],
        credentials: Aws::Credentials.new(GlobalConstant::S3['access_key_id'], GlobalConstant::S3['secret_access_key'])
      })

      @client = Aws::S3::Resource.new
    end

    def acl_value
      @public_read ? 'public-read' : ''
    end

    def get_file_location
      "#{upload_folder}/#{file_name}.#{@extension}"
    end
end