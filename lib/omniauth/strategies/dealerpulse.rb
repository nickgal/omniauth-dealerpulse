require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Dealerpulse < OmniAuth::Strategies::OAuth2
      option :name, 'dealerpulse'
      option :client_options, site: 'https://mydealerpulse.com'

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid { raw_info['id'] }

      info do
        {
          name: raw_info['name'],
          email: raw_info['email'],
          nickname: raw_info['username'],
          first_name: raw_info['first_name'],
          last_name: raw_info['last_name']
        }
      end

      extra do
        {
          raw_info: raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/users/me').parsed
      end

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
