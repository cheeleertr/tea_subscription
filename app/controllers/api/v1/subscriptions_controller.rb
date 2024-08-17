class Api::V1::SubscriptionsController < ApplicationController
  def index
    customer = Customer.find(params[:customer_id])
    subscriptions = customer.subscriptions
    render json: SubscriptionSerializer.format_subscriptions(subscriptions), status: :ok
  end

  def create
    customer = Customer.find(params[:customer_id])
    tea = Tea.find(params[:tea_id])
    subscription = customer.subscriptions.new(subscription_params)

    if subscription.save
      SubscriptionTea.create!(tea: tea, subscription: subscription)
      render json: SubscriptionSerializer.format_subscription(subscription), status: :created
    else
      render json: ErrorSerializer.new(ErrorMessage.new(subscription.errors.full_messages, 422))
      .serialize_json, status: :unprocessable_entity
    end
  end

  def update
    subscription = Subscription.find(params[:id])

    if subscription.update(subscription_params)
      render json: SubscriptionSerializer.format_subscription(subscription)
    else
      render json: ErrorSerializer.new(ErrorMessage.new(subscription.errors.full_messages, 422))
      .serialize_json, status: :unprocessable_entity
    end

  end

  private

  def subscription_params
    params.permit(:title, :price, :status, :frequency)
  end
end