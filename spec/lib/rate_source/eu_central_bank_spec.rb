require 'spec_helper'

describe Money::Bank::DatabaseBank::RateSource::EuCentralBank do
  before do
    Money::Bank::DatabaseBank.currencies = %w(USD EUR AUD)
  end

  it "should fetch rates for configured currencies" do
    rate_fixture_data = File.open(File.dirname(__FILE__) + '/../../eurofxref-daily.xml').read
    expect(Money::Bank::DatabaseBank::RateSource::EuCentralBank).
      to receive(:open).
      with(Money::Bank::DatabaseBank::RateSource::EuCentralBank::ECB_RATES_URL).
      and_return(rate_fixture_data)

    rates = Money::Bank::DatabaseBank::RateSource::EuCentralBank.fetch_rates

    date = Time.parse("2016-07-18 00:00:00 UTC")
    source = Money::Bank::DatabaseBank::RateSource::EuCentralBank::NAME

    rates.should =~ [
      { sourced_at: date, rate_source: source, from_currency: 'EUR', to_currency: 'EUR', rate: 1.0 },
      { sourced_at: date, rate_source: source, from_currency: 'EUR', to_currency: 'USD', rate: 1.1053 },
      { sourced_at: date, rate_source: source, from_currency: 'USD', to_currency: 'EUR', rate: 1.0/1.1053 },
      { sourced_at: date, rate_source: source, from_currency: 'EUR', to_currency: 'AUD', rate: 1.4557 },
      { sourced_at: date, rate_source: source, from_currency: 'AUD', to_currency: 'EUR', rate: 1.0/1.4557 },
      { sourced_at: date, rate_source: source, from_currency: 'AUD', to_currency: 'USD', rate: 1.1053/1.4557 },
      { sourced_at: date, rate_source: source, from_currency: 'USD', to_currency: 'AUD', rate: 1.4557/1.1053 }
    ]
  end
end
