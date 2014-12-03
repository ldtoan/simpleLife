# encoding: utf-8
class MailInfo
  @@options = { :address  => "localhost",
              :port     => 25,
              :domain   => 'zigexn.vn'
      }
  @@mail_to = "namgh@zigexn.vn"
  @@mail_from = ""

  class << self
    def get_options
      @@options
    end

    def get_mail_to
      @@mail_to
    end

    def get_mail_from
      @@mail_from
    end
  end
end