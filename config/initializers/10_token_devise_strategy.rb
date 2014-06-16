require 'devise/strategies/base'

module Devise
  module Strategies
    # Strategy for signing in a user, based on a authenticatable token.
    # This works for both params and http. For the former, all you need to
    # do is to pass the params in the URL:
    #
    #   http://myapp.example.com/?private_token=TOKEN
    #   http://myapp.example.com Header: PRIVATE-TOKEN: TOKEN
    class TokenAuthenticatable < Authenticatable

      def valid?
        super || token
      end

      def authenticate!
        return fail(:invalid_ticket) unless token
        begin
          user = User.find_by(authentication_token: token)
          success!(user)
        rescue Exception => e
          return fail("Unable to authenticate user")
        end
      end

      private

      def token
        params[:private_token].presence ||
            request.headers["PRIVATE-TOKEN"].presence
      end
    end
  end
end