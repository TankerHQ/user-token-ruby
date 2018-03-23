# frozen_string_literal: true
require 'json'

class Server < Sinatra::Base

  # ---------------------------------------------------------------------------
  # User token generation
  # ---------------------------------------------------------------------------

  # TODO: ensure config is stored in a secure place
  configure do
    set config: JSON.parse(File.read('config-trustchain.json'))
  end

  # TODO: replace with your own logic to check a legitimate user is logged in
  #       and to retrieve his user id as needed by the Tanker SDK
  before '/user_token' do
    @user_id = params[:user_id]
    halt 400, 'Invalid user_id parameter' if @user_id.nil? || @user_id == ''
  end

  get '/user_token' do
    # add proper Content-Type header in the response
    content_type 'text/plain'

    # TODO: retrieve the token of the current user if exists
    token = nil

    if token.nil?
      trustchain_id = settings.config['trustchainId'];
      trustchain_private_key = settings.config['trustchainPrivateKey'];
      token = Tanker::UserToken.generate(trustchain_id, trustchain_private_key, @user_id)
      # TODO: store the token in a safe place
    end

    token
  end

  # ---------------------------------------------------------------------------
  # CORS
  # ---------------------------------------------------------------------------

  # All the code in this section is not required if your front-end application
  # and your user token server share the same domain.
  configure do
    enable :cross_origin
  end

  # Activate CORS on all requests
  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  # Preflight request
  options "*" do
    response.headers["Allow"] = "GET, POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
end
