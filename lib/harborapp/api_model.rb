module Harborapp
	module ApiModel

    def self.included(base)
			base.extend ClassMethods
		end

		def initialize(params = {})
			populate(params)
		end

		def populate(params = {})
			params.each do |k,v|
        instance_variable_set "@#{k}", v
			end
		end
	
		module ClassMethods
			attr_accessor :new_record, :errors
		end	

		def errors=(arr); @errors = arr; end
		def errors; @errors; end

		def new_record?
			@new_record.nil? ? true : @new_record
		end

		def success?
			@errors.nil?
		end
	
		def attrs
			{}.tap {|h| instance_variables.each { |var| h[var[1..-1]] = instance_variable_get(var) } }
		end
		
	end
end
