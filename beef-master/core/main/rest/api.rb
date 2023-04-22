#
# Copyright (c) 2006-2023 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - http://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
module BeEF
  module Core
    module Rest
      module RegisterHooksHandler
        def self.mount_handler(server)
          server.mount('/api/hooks', BeEF::Core::Rest::HookedBrowsers.new)
        end
      end

      module RegisterBrowserDetailsHandler
        def self.mount_handler(server)
          server.mount('/api/browserdetails', BeEF::Core::Rest::BrowserDetails.new)
        end
      end

      module RegisterModulesHandler
        def self.mount_handler(server)
          server.mount('/api/modules', BeEF::Core::Rest::Modules.new)
        end
      end

      module RegisterCategoriesHandler
        def self.mount_handler(server)
          server.mount('/api/categories', BeEF::Core::Rest::Categories.new)
        end
      end

      module RegisterLogsHandler
        def self.mount_handler(server)
          server.mount('/api/logs', BeEF::Core::Rest::Logs.new)
        end
      end

      module RegisterAdminHandler
        def self.mount_handler(server)
          server.mount('/api/admin', BeEF::Core::Rest::Admin.new)
        end
      end

      module RegisterServerHandler
        def self.mount_handler(server)
          server.mount('/api/server', BeEF::Core::Rest::Server.new)
        end
      end

      module RegisterAutorunHandler
        def self.mount_handler(server)
          server.mount('/api/autorun', BeEF::Core::Rest::AutorunEngine.new)
        end
      end

      BeEF::API::Registrar.instance.register(BeEF::Core::Rest::RegisterHooksHandler, BeEF::API::Server, 'mount_handler')
      BeEF::API::Registrar.instance.register(BeEF::Core::Rest::RegisterBrowserDetailsHandler, BeEF::API::Server, 'mount_handler')
      BeEF::API::Registrar.instance.register(BeEF::Core::Rest::RegisterModulesHandler, BeEF::API::Server, 'mount_handler')
      BeEF::API::Registrar.instance.register(BeEF::Core::Rest::RegisterCategoriesHandler, BeEF::API::Server, 'mount_handler')
      BeEF::API::Registrar.instance.register(BeEF::Core::Rest::RegisterLogsHandler, BeEF::API::Server, 'mount_handler')
      BeEF::API::Registrar.instance.register(BeEF::Core::Rest::RegisterAdminHandler, BeEF::API::Server, 'mount_handler')
      BeEF::API::Registrar.instance.register(BeEF::Core::Rest::RegisterServerHandler, BeEF::API::Server, 'mount_handler')
      BeEF::API::Registrar.instance.register(BeEF::Core::Rest::RegisterAutorunHandler, BeEF::API::Server, 'mount_handler')

      #
      # Check the source IP is within the permitted subnet
      # This is from extensions/admin_ui/controllers/authentication/authentication.rb
      #
      def self.permitted_source?(ip)
        # test if supplied IP address is valid
        return false unless BeEF::Filters.is_valid_ip?(ip)

        # get permitted subnets
        permitted_ui_subnet = BeEF::Core::Configuration.instance.get('beef.restrictions.permitted_ui_subnet')
        return false if permitted_ui_subnet.nil?
        return false if permitted_ui_subnet.empty?

        # test if ip within subnets
        permitted_ui_subnet.each do |subnet|
          return true if IPAddr.new(subnet).include?(ip)
        end

        false
      end

      #
      # Rate limit through timeout
      # This is from extensions/admin_ui/controllers/authentication/
      #
      # Brute Force Mitigation
      # Only one login request per config_delay_id seconds
      #
      # @param config_delay_id <string> configuration name for the timeout
      # @param last_time_attempt <Time> last time this was attempted
      # @param time_record_set_fn <lambda> callback, setting time on failure
      #
      # @return <boolean>
      def self.timeout?(config_delay_id, last_time_attempt, time_record_set_fn)
        success = true
        time = Time.now
        config = BeEF::Core::Configuration.instance
        fail_delay = config.get(config_delay_id)

        if time - last_time_attempt < fail_delay.to_f
          time_record_set_fn.call(time)
          success = false
        end

        success
      end
    end
  end
end
