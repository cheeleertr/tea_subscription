require "rails_helper"

describe "subscription api" do
  before :each do
    @customer = FactoryBot.create(:customer)
    @tea = FactoryBot.create(:tea)
  end

  context "post /api/v1/customers/:customer_id/subscriptions" do
    it "creates a subscription and returns JSON data with the correct structure and values" do
      subscription_params = {
        title: "Monthly Jasmine Tea",
        price: 10000,
        status: "active",
        frequency: 0,
        tea_id: @tea.id
      }

      post "/api/v1/customers/#{@customer.id}/subscriptions", params: subscription_params.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to be_successful
      expect(response.status).to eq(201)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:data)
      expect(subscription_response[:data]).to be_a(Hash)

      expect(subscription_response[:data]).to have_key(:id)
      expect(subscription_response[:data][:id]).to be_a(Integer)

      expect(subscription_response[:data][:attributes]).to have_key(:title)
      expect(subscription_response[:data][:attributes][:title]).to eq(subscription_params[:title])

      expect(subscription_response[:data][:attributes]).to have_key(:price)
      expect(subscription_response[:data][:attributes][:price]).to eq(subscription_params[:price])

      expect(subscription_response[:data][:attributes]).to have_key(:status)
      expect(subscription_response[:data][:attributes][:status]).to eq(subscription_params[:status])

      expect(subscription_response[:data][:attributes]).to have_key(:frequency)
      expect(subscription_response[:data][:attributes][:frequency]).to eq("monthly")

      expect(subscription_response[:data][:attributes]).to have_key(:customer_id)
      expect(subscription_response[:data][:attributes][:customer_id]).to eq(@customer.id)

      expect(subscription_response[:data][:attributes]).to have_key(:teas)
      expect(subscription_response[:data][:attributes][:teas]).to be_a(Array)

      subscription_response[:data][:attributes][:teas].each do |tea|
        expect(tea).to have_key(:title)
        expect(tea[:title]).to be_a(String)

        expect(tea).to have_key(:id)
        expect(tea[:id]).to be_a(Integer)
      end
    end

    it "returns a 422 status code and errors when the request is invalid" do
      invalid_subscription_params = {
        title: "",
        price: 0,
        status: "active",
        frequency: nil,
        tea_id: @tea.id
      }

      post "/api/v1/customers/#{@customer.id}/subscriptions", params: invalid_subscription_params.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)
    end
  end

  context "patch /api/v1/customers/:customer_id/subscriptions/:id" do
    it "updates a subscription and returns the updated subscription with status 'cancelled'" do
      subscription = FactoryBot.create(:subscription, customer: @customer, status: "active")

      patch "/api/v1/customers/#{@customer.id}/subscriptions/#{subscription.id}?status=cancelled", headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response[:data][:attributes]).to have_key(:status)
      expect(subscription_response[:data][:attributes][:status]).to eq("cancelled")
      subscription.reload
      
      expect(subscription.status).to eq("cancelled")
    end

    it "returns a 404 status code when the subscription does not exist" do
      patch "/api/v1/customers/#{@customer.id}/subscriptions/0", headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors].first[:title]).to eq("Couldn't find Subscription with 'id'=0")
    end
  end

  context "get /api/v1/customers/:customer_id/subscriptions" do
    it "returns all of a customer's subscriptions" do
      active_subscription = FactoryBot.create(:subscription, customer: @customer, status: "active")
      cancelled_subscription = FactoryBot.create(:subscription, customer: @customer, status: "cancelled")

      get "/api/v1/customers/#{@customer.id}/subscriptions", headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      subscriptions_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscriptions_response).to be_an(Hash)
      
      expect(subscriptions_response).to have_key(:data)
      expect(subscriptions_response[:data]).to be_a(Array)
      expect(subscriptions_response[:data].size).to eq(2)

      expect(subscriptions_response[:data].first).to have_key(:id)
      expect(subscriptions_response[:data].first[:id]).to eq(active_subscription.id)

      expect(subscriptions_response[:data].first[:attributes]).to have_key(:title)
      expect(subscriptions_response[:data].first[:attributes][:title]).to eq(active_subscription.title)

      expect(subscriptions_response[:data].first[:attributes]).to have_key(:price)
      expect(subscriptions_response[:data].first[:attributes][:price]).to eq(active_subscription.price)

      expect(subscriptions_response[:data].first[:attributes]).to have_key(:status)
      expect(subscriptions_response[:data].first[:attributes][:status]).to eq("active")

      expect(subscriptions_response[:data].first[:attributes]).to have_key(:frequency)
      expect(subscriptions_response[:data].first[:attributes][:frequency]).to eq(active_subscription.frequency)
    end

    it "returns a 404 status code when the customer does not exist" do
      get "/api/v1/customers/0/subscriptions", headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors].first[:title]).to eq("Couldn't find Customer with 'id'=0")
    end
  end
end
