class RedirectMailInterceptor
	def self.delivering_email(message)
		message.subject = "#{message.to} #{message.subject}"
		message.to = ["joelsugarman@yahoo.co.uk"]
	end
end
