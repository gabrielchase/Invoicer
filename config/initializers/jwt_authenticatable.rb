module Devise 
  module Strategies
    class JWTAuthenticatable < Base 
      def authenticate!
        token = get_jwt
        
        if token.present? 
          payload = WebToken.decode(token)
          
          if payload == :expired
            return fail(:invalid)
          end

          # byebug

          resource = mapping.to.find(payload.first['user_id'])

          if not resource
            return fail(:not_found_in_database)
          end 

          success!(resource)
        else
          fail(:invalid)
        end 
      end 

      private 

      def get_jwt
        auth_header.present? && auth_header.split(' ').last()
      end 

      def auth_header
        request.headers['Authorization']
      end 
    end 
  end 
end 