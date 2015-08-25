class Payment
  include Mongoid::Document
  field :response, type: ActiveMerchant::Billing::Response
end
