# frozen_string_literal: true
require 'securerandom'
require 'rbnacl/libsodium'

module Tanker
  module Crypto
    HASH_MIN_SIZE = RbNaCl::Hash::Blake2b::BYTES_MIN # 16

    def self.generichash(input, size)
      binary_input = input.dup.force_encoding(Encoding::ASCII_8BIT)
      RbNaCl::Hash.blake2b(binary_input, digest_size: size)
    end

    # We need this static method since a RbNaCl::SigningKey instance can't be
    # directly initialized with a given signing_key
    def self.sign_detached(message, signing_key)
      signature_bytes = RbNaCl::SigningKey.signature_bytes
      buffer = RbNaCl::Util.prepend_zeros(signature_bytes, message)
      buffer_len = RbNaCl::Util.zeros(8) # 8 bytes for an int64 (FFI::Type::LONG_LONG.size)

      RbNaCl::SigningKey.sign_ed25519(buffer, buffer_len, message, message.bytesize, signing_key)

      buffer[0, signature_bytes]
    end

    def self.generate_signing_key
      RbNaCl::SigningKey.generate
    end

    def self.random_bytes(size)
      SecureRandom.bytes(size)
    end
  end
end
