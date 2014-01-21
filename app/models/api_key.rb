class ApiKey
  include Mongoid::Document
  field :app_id, type: BSON::ObjectId
  field :user_id, type: BSON::ObjectId
  field :access_token, type: String
  field :scopes, type: Array
  field :expires_at, type: Time, default: ->{Time.now+300.minutes}

  before_create :generate_access_token
  private
  def generate_access_token
    begin
     self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
end
