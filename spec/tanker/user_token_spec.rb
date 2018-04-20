# frozen_string_literal: true
RSpec.describe Tanker::UserToken do
  before do
    @trustchain = {
      id: 'AzES0aJwDCej9bQVY9AUMZBCLdX0msEc/TJ4DOhZaQs=',
      pk: 'dOeLBpHz2IF37UQkS36sXomqEcEAjSyCsXZ7irn9UQA=',
      sk: 'cBAq6A00rRNVTHicxNHdDFuq6LNUo6gAz58oKqy9CGd054sGkfPYgXftRCRLfqxeiaoRwQCNLIKxdnuKuf1RAA=='
    }
    @user_id = 'matz@tanker.io'
  end

  it 'has a private constructor' do
    args = [@trustchain[:id], @trustchain[:sk], @user_id]
    expect {
      Tanker::UserToken.new(*args)
    }.to raise_exception(NoMethodError)
  end

  [nil, 1234, ['1234'], {}].each do |value|

    it "raises a TypeError if argument is a #{value.class} instead of a string" do
      args = [@trustchain[:id], @trustchain[:sk], @user_id]

      for pos in 0..2
        # make a single argument invalid at a time
        invalid_args = args.dup.tap { |arr| arr[pos] = value }

        expect {
          Tanker::UserToken.generate(*invalid_args)
        }.to raise_exception(TypeError)
      end
    end

  end

  it 'raises an ArgumentError if argument is an invalid base64 string' do
    args = [@trustchain[:id], @trustchain[:sk], @user_id]

    for pos in 0..1
      # make a single argument invalid at a time
      invalid_args = args.dup.tap { |arr| arr[pos] = '&:,?' }

      expect {
        Tanker::UserToken.generate(*invalid_args)
      }.to raise_exception(ArgumentError)
    end
  end

  it 'returns a valid token signed with the trustchain private key' do
    b64_token = Tanker::UserToken.generate(@trustchain[:id], @trustchain[:sk], @user_id)
    json_token = Base64.decode64(b64_token)
    token = JSON.parse(json_token)

    # check valid control byte in user secret
    hashed_user_id = Base64.decode64(token['user_id'])
    user_secret = Base64.decode64(token['user_secret'])
    expect(hashed_user_id.bytesize).to be 32
    expect(user_secret.bytesize).to be 32
    size = Tanker::Crypto::HASH_MIN_SIZE
    control = Tanker::Crypto.generichash(user_secret[0..-2] + hashed_user_id, size)
    expect(user_secret.bytes.last).to eq(control.bytes.first)

    # check with valid signature
    signed_data = Base64.decode64(token['ephemeral_public_signature_key']) +
                  Base64.decode64(token['user_id'])

    verify_key = RbNaCl::VerifyKey.new(Base64.decode64(@trustchain[:pk]))

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
