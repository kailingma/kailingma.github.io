#
# Copyright (c) 2006-2023 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - http://beefproject.com
# See the file 'doc/COPYING' for copying permission
#

module BeEF
  module Extension
    module SocialEngineering
      class SEngRest < BeEF::Core::Router::Router
        config = BeEF::Core::Configuration.instance

        before do
          error 401 unless params[:token] == config.get('beef.api_token')
          halt 401 unless BeEF::Core::Rest.permitted_source?(request.ip)
          headers 'Content-Type' => 'application/json; charset=UTF-8',
                  'Pragma' => 'no-cache',
                  'Cache-Control' => 'no-cache',
                  'Expires' => '0'
        end

        # Example: curl -H "Content-Type: application/json; charset=UTF-8" -d json_body
        # -X POST http://127.0.0.1:3000/api/seng/clone_page?token=851a937305f8773ee82f5259e792288cdcb01cd7
        #
        # Example json_body:
        # {
        #     "url": "https://accounts.google.com/ServiceLogin?service=mail&continue=https://mail.google.com/mail/"
        #     "mount": "/gmail",
        #     "dns_spoof": true
        # }
        post '/clone_page' do
          request.body.rewind
          begin
            body = JSON.parse request.body.read
            uri = body['url']
            mount = body['mount']
            use_existing = body['use_existing']
            dns_spoof = body['dns_spoof']

            if !uri.nil? && !mount.nil?
              if (uri =~ URI::DEFAULT_PARSER.make_regexp).nil? # invalid URI
                print_error 'Invalid URI'
                halt 401
              end

              unless mount[%r{^/}] # mount needs to start with /
                print_error 'Invalid mount (need to be a relative path, and start with / )'
                halt 401
              end

              web_cloner = BeEF::Extension::SocialEngineering::WebCloner.instance
              success = web_cloner.clone_page(uri, mount, use_existing, dns_spoof)

              if success
                result = {
                  'success' => true,
                  'mount' => mount
                }.to_json
              else
                result = {
                  'success' => false
                }.to_json
                halt 500
              end
            end
          rescue StandardError
            print_error 'Invalid JSON input passed to endpoint /api/seng/clone_page'
            error 400 # Bad Request
          end
        end
      end
    end
  end
end
