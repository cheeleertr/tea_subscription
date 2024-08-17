class SubscriptionSerializer
  include JSONAPI::Serializer

  def self.format_subscription(subscription)
    {
      data: {
        type: "subscriptions",
        id: subscription.id,
        attributes: {
          title: subscription.title,
          price: subscription.price,
          status: subscription.status,
          frequency: subscription.frequency,
          customer_id: subscription.customer.id,
          teas: subscription.teas.map { |tea| {title: tea.title, id: tea.id}}
        }
      }
    }
  end

  def self.format_subscriptions(subscriptions)
    {
      data: subscriptions.map do |subscription|
        {
          type: "subscriptions",
          id: subscription.id,
          attributes: {
            title: subscription.title,
            price: subscription.price,
            status: subscription.status,
            frequency: subscription.frequency,
            customer_id: subscription.customer.id,
            teas: subscription.teas.map { |tea| {title: tea.title, id: tea.id}}
          }
        }
      end
    }
  end
  
end