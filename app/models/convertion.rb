class Convertion < ActiveRecord::Base

  before_create :create_token
  mount_uploader :encoded_file, ContainerEncodedFileUploader

  def create_token
    self.token = UUIDTools::UUID.random_create.to_s
  end

  def download_title
    return read_attribute :encoded_file
  end
end
