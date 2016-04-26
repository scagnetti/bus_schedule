class User < ActiveRecord::Base

	class NotAuthorized < StandardError
	end

	has_secure_password
	validates_presence_of :password, :on => :create
	
end
