require_relative "api_model"

module Harborapp
  class Account
    include ApiModel
    attr_accessor :api_key, :email

    def self.login(email, password)
      params = {:basic_username => email, :basic_password => password}
      Harborapp::Api.request :post, "/login", params
    end

		def write_creds
			File.open(File.expand_path("~/.harbor_auth"), "w") do |f|
				f.write({api_key: api_key, email: email}.to_json)
			end
		end

		def self.from_creds
			File.open(File.expand_path("~/.harbor_auth"), "r") do |f|
				hash = JSON.parse f.read
				self.new hash
			end
		end
	
		def self.logout
			File.rm(File.expand_path("~/.harbor_auth"))
		end
  end
end
