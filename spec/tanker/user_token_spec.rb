# frozen_string_literal: true
RSpec.describe Tanker::UserToken do
  it 'has a version number' do
    expect(Tanker::UserToken::VERSION).not_to be nil
  end

  it 'returns a valid token signed with the trustchain private key' do
    trustchain = {
      id: 'AzES0aJwDCej9bQVY9AUMZBCLdX0msEc/TJ4DOhZaQs=',
      pk: 'dOeLBpHz2IF37UQkS36sXomqEcEAjSyCsXZ7irn9UQA=',
      sk: 'cBAq6A00rRNVTHicxNHdDFuq6LNUo6gAz58oKqy9CGd054sGkfPYgXftRCRLfqxeiaoRwQCNLIKxdnuKuf1RAA=='
    }

    user_id = 'matz@tanker.io'

    b64_token = Tanker::UserToken.generate(trustchain[:id], trustchain[:sk], user_id)
    json_token = Base64.decode64(b64_token)
    token = JSON.parse(json_token)

    # check valid control byte in user secret
    hashed_user_id = Base64.decode64(token['user_id'])
    user_secret = Base64.decode64(token['user_secret'])
    expect(hashed_user_id.bytesize).to be 32
    expect(user_secret.bytesize).to be 32
    size = Tanker::UserToken::Crypto::HASH_MIN_SIZE
    control = Tanker::UserToken::Crypto.generichash(user_secret[0..-2] + hashed_user_id, size)
    expect(user_secret.bytes.last).to eq(control.bytes.first)

    # check with valid signature
    signed_data = Base64.decode64(token['ephemeral_public_signature_key']) +
                  Base64.decode64(token['user_id'])

    verify_key = RbNaCl::VerifyKey.new(Base64.decode64(trustchain[:pk]))

    expect {
      verify_key.verify(Base64.decode64(token['delegation_signature']), signed_data)
    }.not_to raise_exception # no RbNaCl::BadSignatureError

    # check with invalid signature
    expect {
      signature_length = RbNaCl::SigningKey.signature_bytes
      random_signature = RbNaCl::Random.random_bytes(signature_length)
      verify_key.verify(random_signature, signed_data)
    }.to raise_exception(RbNaCl::BadSignatureError)
  end
end

RSpec.describe Tanker::UserToken::Crypto do
  it 'should match the RFC7693 BLAKE2b-512 test vector for "abc"' do
    # To check that the hash function is implemented correctly, we compute a test vector,
    #  which is a known expected output for a given input, defined in the standard
    hex_vector = 'BA80A53F981C4D0D6A2797B69F12F6E94C212F14685AC4B74B12BB6FDBFFA2D17D87C5392AAB792DC252D5DE4533CC9518D38AA8DBF1925AB92386EDD4009923'
    vector = [hex_vector].pack('H*')
    input = 'abc'.dup.force_encoding(Encoding::ASCII_8BIT)
    output = Tanker::UserToken::Crypto.generichash(input, 64)

    expect(output).to eq(vector)
  end
end
