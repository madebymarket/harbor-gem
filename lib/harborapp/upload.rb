require_relative "api_model"

module Harborapp
  class Upload
    include ApiModel
    attr_accessor :curl_params

		def self.get_curl_params file=nil
			params = {}
      Harborapp::Api.request :post, "/uploads/curl", params
		end

		def deliver
			Harborapp::Api.xml_request :post, "https://s3.amazonaws.com/harborapp", curl_params
		end

  end
end
