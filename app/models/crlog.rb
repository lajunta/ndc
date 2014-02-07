class Crlog
  include Mongoid::Document
  include Mongoid::Timestamps
  field :semester, type: String
  field :croom, type: String
  field :banji, type: String
  field :use_date, type: Date
  field :course_name, type: String
  field :jiece, type: String
  field :computer_status, type: String
  field :garbage_status, type: String
  field :place_status, type: String
  field :status, type: String
  field :loger, type: String
  field :closed_by, type: String
  field :desc, type: String
  embeds_many :crlog_replys
  index({semester: 1})
  index({croom: 1})
  index({banji: 1})
  index({use_date: 1})
  index({course_name: 1})
  index({loger: 1})
  index({created_at: 1})
end

