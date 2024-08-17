require "rails_helper"

RSpec.describe ErrorMessage do
  it "can initialize with a message and status code" do
    message = "Invalid Credentials"
    status_code = 401
    error_message = ErrorMessage.new(message, status_code)

    expect(error_message).to be_a ErrorMessage
    expect(error_message.message).to eq(message)
    expect(error_message.status_code).to eq(status_code)
  end
end