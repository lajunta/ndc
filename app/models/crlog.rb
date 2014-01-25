class Crlog
  include Mongoid::Document
  include Mongoid::Timestamps
  field :croom, type: String
  field :banji, type: String
  field :use_date, type: String
  field :course_name, type: String
  field :jiece, type: String
  field :computer_status, type: String
  field :garbage_status, type: String
  field :place_status, type: String
  field :status, type: String
  field :loger, type: String
  field :closed_by, type: String
  field :desc, type: String
end
