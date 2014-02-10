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
end
