# frozen_string_literal: true
require 'tanker/crypto'
require 'base64'
require 'json'

module Tanker
  class UserToken
    BLOCK_HASH_SIZE = 32
    USER_SECRET_SIZE = 32

    def initialize(trustchain_id, trustchain_private_key, user_id)
      @trustchain_id = trustchain_id
      @trustchain_private_key = trustchain_private_key
      @user_id = user_id
    end

    def serialize
      Base64.strict_encode64(JSON.generate(as_json))
    end

    private
    def hashed_user_id
      return @hashed_user_id if @hashed_user_id

      binary_user_id = @user_id.dup.force_encoding(Encoding::ASCII_8BIT)
      @hashed_user_id = Crypto.generichash(binary_user_id + @trustchain_id, BLOCK_HASH_SIZE)
    end

    def user_secret
      return @user_secret if @user_secret

      random_bytes = Crypto.random_bytes(USER_SECRET_SIZE - 1);
      check = Crypto.generichash(random_bytes + hashed_user_id, Crypto::HASH_MIN_SIZE)
      @user_secret = random_bytes + check[0]
    end

    def signing_key
      @signing_key ||= Crypto.generate_signing_key
    end

    def signature
      return @signature if @signature

      message = signing_key.verify_key.to_bytes + hashed_user_id
      @signature = Crypto.sign_detached(message, @trustchain_private_key)
    end

    def as_json
      @as_json ||= {
        delegation_signature: Base64.strict_encode64(signature),
        ephemeral_public_signature_key: Base64.strict_encode64(signing_key.verify_key.to_bytes),
        ephemeral_private_signature_key: Base64.strict_encode64(signing_key.keypair_bytes),
        user_id: Base64.strict_encode64(hashed_user_id),
        user_secret: Base64.strict_encode64(user_secret)
      }
    end

    class << self
      # private constructor: only generate can create a UserToken instance
      private :new

      public
      def generate(b64_trustchain_id, b64_trustchain_private_key, user_id)
        # raise TypeError if not a String
        {
          trustchain_id: b64_trustchain_id,
          trustchain_private_key: b64_trustchain_private_key,
          user_id: user_id
        }.each_pair do |name, value|
          unless value.is_a?(String)
            raise TypeError.new("expected #{name} to be a String but was a #{value.class}")
          end
        end

        # raise ArgumentError if invalid base64
        binary_trustchain_id = Base64.strict_decode64(b64_trustchain_id)
        binary_trustchain_private_key = Base64.strict_decode64(b64_trustchain_private_key)

        token = new(binary_trustchain_id, binary_trustchain_private_key, user_id)
        token.serialize
      end
    end
  end
end
