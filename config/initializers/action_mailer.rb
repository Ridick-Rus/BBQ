# https://github.com/rails/rails/pull/46650

module ActionMailer
  module DeliveryMethods
    included do
      # Do not make this inheritable, because we always want it to propagate
      cattr_accessor :raise_delivery_errors, default: true
      cattr_accessor :perform_deliveries, default: true
      cattr_accessor :deliver_later_queue_name, default: :mailers

      class_attribute :delivery_methods, default: {}.freeze
      class_attribute :delivery_method, default: :smtp

      add_delivery_method :smtp, Mail::SMTP,
                          address:              "goodprog-projects.ru",
                          port:                 25,
                          domain:               "goodprog-projects.ru",
                          user_name:            nil,
                          password:             nil,
                          authentication:       nil,
                          enable_starttls_auto: true

      add_delivery_method :file, Mail::FileDelivery,
                          location: defined?(Rails.root) ? "#{Rails.root}/tmp/mails" : "#{Dir.tmpdir}/mails"

      add_delivery_method :sendmail, Mail::Sendmail,
                          location:  "/usr/sbin/sendmail",
                          # See breaking change in the mail gem - https://github.com/mikel/mail/commit/7e1196bd29815a0901d7290c82a332c0959b163a
                          arguments: Gem::Version.new(Mail::VERSION.version) >= Gem::Version.new("2.8.0") ? %w[-i] : "-i"

      add_delivery_method :test, Mail::TestMailer
    end
  end
end
