require_relative "../lib/harborapp"
require_relative "doubles/jack"
require_relative "doubles/account"
require_relative "doubles/upload"

describe Harborapp do
	before :all do
		@jack = Harborapp::ApiDouble.new
		#Harborapp.api_key = "good-user-api-key"
		Harborapp::Api.jack = @jack
	end

	it "should let us set an API key on Harborapp module" do
		Harborapp.api_key = "test-api-key"
		Harborapp.api_key.should == "test-api-key"
	end

	context "Logging in and setting credentials" do
		it "should let a user log in with proper email address and password" do
			@jack.should_receive(:execute).and_return login_success
			account = Harborapp::Account.login "user@harborapp.com", "good-password"
			account._entity.should_not be_nil
			account._entity.object.should be_a Harborapp::Account
			account.api_key.should_not be_empty
			account.email.should_not be_empty
		end
		it "should save their api key once logged in" do
			file = mock('file')
			File.should_receive(:open).with(File.expand_path("~/.harbor_auth"), "w").and_yield(file)
			file.should_receive(:write).with({api_key: "test-api-key", email: "test@harbor.madebymarket.com"}.to_json)
			account = Harborapp::Account.new(
				email: "test@harbor.madebymarket.com",
				api_key: "test-api-key"
			)
			account.write_creds
		end
		it "should read api key from creds file" do
			file = mock('file')
			File.should_receive(:exist?).with(File.expand_path("~/.harbor_auth")).and_return true
			File.should_receive(:open).with(File.expand_path("~/.harbor_auth"), "r").and_yield(file)
			file.should_receive(:read).and_return({api_key: "test-api-key", email: "test@harbor.madebymarket.com"}.to_json)
			account = Harborapp::Account.from_creds
			account.api_key.should eql("test-api-key")
			account.email.should eql("test@harbor.madebymarket.com")
		end
		it "should return nice message with forgot-password link when incorrect"
		it "should let a user log out and delete their api key" do
			file = mock('file')
			Harborapp::Account.logout
		end
	end

	context "Registering for an account" do
		it "should let a user register for an account with an email and password"
	end

	context "sending files" do
		it "should get curl opts without a filename" do
			@jack.should_receive(:execute).and_return curl_opts_without_filename
			upload = Harborapp::Upload.get_curl_params "test.jpg"
			upload.curl_params.should_not be_nil
			upload.curl_params["AWSAccessKeyId"].should_not be_nil
			upload.curl_params["acl"].should == "public-read"
			upload.curl_params["key"].should == "__FILENAME__"
			upload.curl_params["content-type"].should == "__CONTENT-TYPE__"
			upload.curl_params["file"].should == "__FILE__"
			upload.curl_params["x-amz-security-token"].should_not be_empty
			upload.curl_params["success_action_status"].should == "200"
			upload.curl_params["policy"].should_not be_empty
			upload.curl_params["signature"].should_not be_empty
		end
		pending "should send a file using rest_client and get back its s3 url" do
			@jack.should_receive(:execute).and_return curl_opts_without_filename, success_response
			upload = Harborapp::Upload.get_curl_params "test.jpg"
			puts upload.deliver
		end
		it "should get curl opts with a filename"
		it "should get curl opts for a free-level transfer without an api key"
		it "should let a user send a file using their api key"
		it "should let a user specify a gpg key to use to encrypt a file before upload"
		it "should send a file through the free upload area without a key"
	end
end
