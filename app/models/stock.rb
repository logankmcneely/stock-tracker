class Stock < ApplicationRecord

  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_tokens][:publishable_token],
      secret_token: Rails.application.credentials.iex_client[:sandbox_tokens][:secret_token],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    new(
      ticker: ticker_symbol,
      name: client.company(ticker_symbol).company_name,
      last_price: client.price(ticker_symbol)
    )
  end

end