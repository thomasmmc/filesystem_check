require 'net/smtp'

message = <<MESSAGE_END
From: Ruby
To: #{@recipients.join(",")}
Subject: #{@subject}

#{@body}

Thank You,
Your trusty ruby script
MESSAGE_END

Net::SMTP.start('smtp.yourdomain.com') do |smtp|
  smtp.send_message message, 'ruby@yourdomain.com', @recipients
end
