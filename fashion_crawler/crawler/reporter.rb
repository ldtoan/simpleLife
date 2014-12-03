# encoding: utf-8
require 'mail'
require File.expand_path(File.dirname(__FILE__)) + '/mail_info.rb'
module Report

    def send_email(site, group_number)

      string_output = "
      <!DOCTYPE html>
      <html>
      <head>
        <meta content=\"text/html; charset=UTF-8\" http-equiv=\"Content-Type\" />
      </head>
      <body>
        <p>
            Please check issues for site :<br/>
            -------------------------------------------------------------------<br/>
            #{site} in group #{group_number}.<br/>
            -------------------------------------------------------------------<br/><br/>
        </p>
      </body>
      </html>"

      options = MailInfo.get_options

      Mail.defaults do
          delivery_method :smtp, options
      end
      Mail.deliver do
          to MailInfo.get_mail_to
          #cc 'hieulh@zigexn.vn;giangtran@zigexn.vn'
          from MailInfo.get_mail_from
          subject 'No jobs crawled'
          html_part do
            content_type 'text/html; charset=UTF-8'
            body string_output
          end
      end
    end

end
