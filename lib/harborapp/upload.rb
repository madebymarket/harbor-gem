require_relative "api_model"
require "securerandom"

module Harborapp
  class Upload
    include ApiModel
    attr_accessor :file_path, :curl_params, :s3_folder, :key

		def self.get_curl_params file
			params = { :file => file, :size => File.size(file) }
      upload = Harborapp::Api.request :post, "/uploads/curl", params
			if upload.success?
				upload.file_path = file
				upload
			else
				puts upload.errors
				return false
			end
		end

		def deliver
			`curl https://s3.amazonaws.com/harborapp -F AWSAccessKeyId="#{curl_params["AWSAccessKeyId"]}" -F acl="public-read"  -F key="#{key}" -F "content-type=#{curl_params["content-type"]}" -F "x-amz-security-token=#{curl_params["x-amz-security-token"]}" -F success_action_status="200" -F policy="#{curl_params["policy"]}" -F signature="#{curl_params["signature"]}" -F file=@"#{file_path}"`
		end

  end
end
