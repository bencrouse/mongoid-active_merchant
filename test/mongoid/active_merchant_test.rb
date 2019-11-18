require 'test_helper'

class Mongoid::ActiveMerchantTest < Minitest::Test
  def setup
    @response = ActiveMerchant::Billing::Response.new(
      true,
      'Success message',
      { 'param' => 'foo' },
      {
        test: true,
        authorization: '53433',
        fraud_review: false,
        error_code: 0,
        emv_authorization: '123',
        cvv_result: 'M',
        avs_result: {
          code: 'U',
          street_match: 'A',
          postal_match: 'B'
        }
      }
    )
  end

  def test_that_it_has_a_version_number
    refute_nil ::Mongoid::ActiveMerchant::VERSION
  end

  def test_mongoizing_an_instance
    result = @response.mongoize

    assert_instance_of(Hash, result)
    assert(result['success'])
    assert_equal(result['message'], 'Success message')
    assert_equal(result['params'], { 'param' => 'foo' })

    assert_instance_of(Hash, result['options'])
    assert(result['options']['test'])
    assert_equal(result['options']['authorization'], '53433')
    assert_equal(result['options']['fraud_review'], false)
    assert_equal(result['options']['error_code'], 0)
    assert_equal(result['options']['emv_authorization'], '123')
    assert_equal(result['options']['cvv_result'], 'M')

    assert_instance_of(Hash, result['options']['avs_result'])
    assert_equal(result['options']['avs_result']['code'], 'U')
    assert_equal(result['options']['avs_result']['street_match'], 'A')
    assert_equal(result['options']['avs_result']['postal_match'], 'B')
  end

  def test_demongoizing
    db_value = @response.mongoize
    result = ActiveMerchant::Billing::Response.demongoize(db_value)

    assert(result.success?)
    assert_equal(result.message, 'Success message')
    assert_equal(result.params, { 'param' => 'foo' })
    assert(result.test?)
    assert_equal(result.authorization, '53433')
    refute(result.fraud_review?)
    assert_equal(result.error_code, 0)
    assert_equal(result.emv_authorization, '123')
    assert_equal(result.cvv_result['code'], 'M')
    assert_equal(result.avs_result['code'], 'U')
    assert_equal(result.avs_result['street_match'], 'A')
    assert_equal(result.avs_result['postal_match'], 'B')
  end

  def test_mongoizing
    result = ActiveMerchant::Billing::Response.mongoize(@response)
    assert_equal(result, @response.mongoize)
  end

  def test_evolving
    assert_raises(RuntimeError) do
      ActiveMerchant::Billing::Response.evolve(@response)
    end
  end

  def test_saving_a_response_attribute
    model = Payment.create!(response: @response)
    model.reload
    result = model.response

    assert(result.success?)
    assert_equal(result.message, 'Success message')
    assert_equal(result.params, { 'param' => 'foo' })
    assert(result.test?)
    assert_equal(result.authorization, '53433')
    refute(result.fraud_review?)
    assert_equal(result.error_code, 0)
    assert_equal(result.emv_authorization, '123')
    assert_equal(result.cvv_result['code'], 'M')
    assert_equal(result.avs_result['code'], 'U')
    assert_equal(result.avs_result['street_match'], 'A')
    assert_equal(result.avs_result['postal_match'], 'B')
  end

  def test_demongoizing_blank_object
    assert_nil(ActiveMerchant::Billing::Response.demongoize(nil))
  end

  def test_to_json
    as_json = @response.to_json
    result = ActiveMerchant::Billing::Response.demongoize(JSON.parse(as_json))
    pretty = JSON.pretty_generate(@response.as_json)

    assert(result.success?)
    assert_equal(result.message, 'Success message')
    assert_equal(result.params, { 'param' => 'foo' })
    assert(result.test?)
    assert_equal(result.authorization, '53433')
    refute(result.fraud_review?)
    assert_equal(result.error_code, 0)
    assert_equal(result.emv_authorization, '123')
    assert_equal(result.cvv_result['code'], 'M')
    assert_equal(result.avs_result['code'], 'U')
    assert_equal(result.avs_result['street_match'], 'A')
    assert_equal(result.avs_result['postal_match'], 'B')
    assert_includes(pretty, @response.message)
  end
end
