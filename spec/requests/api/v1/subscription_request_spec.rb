require "rails_helper"

describe "subscription api" do
  before :each do
    @customer = create!(:customer)
    @tea = create!(:tea)
    @subscription = create!(:subscription, customer: @customer, tea: @tea, status: "active")
  end

  context "post /customers/:customer_id/subscriptions" do
    it "creates a subscription and returns JSON data with the correct structure and values" do
      subscription_params = {
        title: "Monthly Jasmine Tea",
        price: 10000,
        status: "active",
        frequency: 0,
        tea_id: tea.id
      }

      post "/customers/#{customer.id}/subscriptions", params: subscription_params.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to be_successful
      expect(response.status).to eq(201)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:data)
      expect(subscription_response[:data]).to be_a(Hash)

      expect(subscription_response[:data]).to have_key(:id)
      expect(subscription_response[:data][:id]).to be_a(Integer)

      expect(subscription_response[:data]).to have_key(:title)
      expect(subscription_response[:data][:title]).to eq(subscription_params[:title])

      expect(subscription_response[:data]).to have_key(:price)
      expect(subscription_response[:data][:price]).to eq(subscription_params[:price])

      expect(subscription_response[:data]).to have_key(:status)
      expect(subscription_response[:data][:status]).to eq(subscription_params[:status])

      expect(subscription_response[:data]).to have_key(:frequency)
      expect(subscription_response[:data][:frequency]).to eq(subscription_params[:frequency])

      expect(subscription_response[:data]).to have_key(:customer_id)
      expect(subscription_response[:data][:customer_id]).to eq(customer.id)

      expect(subscription_response[:data]).to have_key(:tea_id)
      expect(subscription_response[:data][:tea_id]).to eq(tea.id)
    end

    it "returns a 422 status code and errors when the request is invalid" do
      invalid_subscription_params = {
        title: "",
        price: 0,
        status: "active",
        frequency: nil,
        tea_id: nil
      }

      post "/customers/#{customer.id}/subscriptions", params: invalid_subscription_params.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)
    end
  end

  context "patch /customers/:customer_id/subscriptions/:id" do
    it "updates a subscription and returns the updated subscription with status 'cancelled'" do
      subscription = create!(:subscription, customer: @customer, tea: @tea, status: "active")

      patch "/customers/#{customer.id}/subscriptions/#{subscription.id}?status=cancelled", headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response[:data]).to have_key(:status)
      expect(subscription_response[:data][:status]).to eq("cancelled")
      expect(subscription.status.cancelled?).to eq(true)
    end

    it "returns a 404 status code when the subscription does not exist" do
      patch "/customers/#{customer.id}/subscriptions/0", headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors].first[:title]).to eq("Subscription not found")
    end
  end

  context "get /customers/:customer_id/subscriptions" do
    it "returns all of a customer's subscriptions" do
      active_subscription = create!(:subscription, customer: @customer, tea: @tea, status: "active")
      cancelled_subscription = create!(:subscription, customer: @customer, tea: @tea, status: "cancelled")

      get "/customers/#{customer.id}/subscriptions", headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      subscriptions_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscriptions_response).to be_an(Array)
      expect(subscriptions_response.size).to eq(2)

      expect(subscriptions_response).to have_key(:data)
      expect(subscriptions_response[:data]).to be_a(Array)

      expect(subscriptions_response[:data].first).to have_key(:id)
      expect(subscriptions_response[:data].first[:id]).to eq(@user.id)

      expect(subscriptions_response[:data].first).to have_key(:title)
      expect(subscriptions_response[:data].first[:title]).to eq(active_subscription.title)

      expect(subscriptions_response[:data].first).to have_key(:price)
      expect(subscriptions_response[:data].first[:price]).to eq(active_subscription.price)

      expect(subscriptions_response[:data].first).to have_key(:status)
      expect(subscriptions_response[:data].first[:status]).to eq("active")

      expect(subscriptions_response[:data].first).to have_key(:frequency)
      expect(subscriptions_response[:data].first[:frequency]).to eq(active_subscription.frequency)
    end

    it "returns a 404 status code when the customer does not exist" do
      get "/customers/0/subscriptions", headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors].first[:title]).to eq("Customer not found")
    end
  end
end
