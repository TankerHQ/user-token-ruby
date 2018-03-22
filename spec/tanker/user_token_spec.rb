# frozen_string_literal: true
RSpec.describe Tanker::UserToken do
  it "has a version number" do
    expect(Tanker::UserToken::VERSION).not_to be nil
  end
end

RSpec.describe Tanker::UserToken::Crypto do
  it 'should match the RFC7693 BLAKE2b-512 test vector for "abc"' do
    # To check that the hash function is implemented correctly, we compute a test vector,
    #  which is a known expected output for a given input, defined in the standard
    hex_vector = 'BA80A53F981C4D0D6A2797B69F12F6E94C212F14685AC4B74B12BB6FDBFFA2D17D87C5392AAB792DC252D5DE4533CC9518D38AA8DBF1925AB92386EDD4009923'
    vector = [hex_vector].pack('H*')
    input = 'abc'.force_encoding(Encoding::ASCII_8BIT)
    output = Tanker::UserToken::Crypto.generichash(input, 64)

    expect(output).to eq(vector)
  end
end
