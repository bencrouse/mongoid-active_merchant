# Mongoid::ActiveMerchant

This gem adds support for serializing/deserializing an ActiveMerchant::Billing::Response for storage with a Mongoid model.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid-active_merchant'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-active_merchant

## Usage

```ruby
class Payment
  include Mongoid::Document
  field :response, type: ActiveMerchant::Billing::Response
end

card = ActiveMerchant::Billing::CreditCard.new(
  number: '4111111111111111',
  month: '8',
  year: '2009',
  first_name: 'Tobias',
  last_name: 'Luetke',
  verification_value: '123'
)

payment = Payment.new
response = ActiveMerchant::Billing::BogusGateway.new.authorize(1000, card)

payment.response = response
payment.save!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bencrouse/mongoid-active_merchant.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

