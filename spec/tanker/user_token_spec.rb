# frozen_string_literal: true
RSpec.describe Tanker::UserToken do
  it "has a version number" do
    expect(Tanker::UserToken::VERSION).not_to be nil
  end
end
