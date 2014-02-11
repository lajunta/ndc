class CrApply
  include Mongoid::Document
  include Mongoid::Timestamps
  field :applyer, type: String
  field :semester, type: String
  field :croom, type: String
  field :banji, type: String
  field :course, type: String
  field :wday, type: String
  field :jiece, type: String
  field :status,type: Boolean
  index({applyer: 1})
  index({semester: 1})
  index({croom: 1})
  index({banji: 1})
  index({course: 1})
  index({wday: 1})
  index({jiece: 1})
  index({status: 1})
end
