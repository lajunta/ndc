class CrlogReply
  include Mongoid::Document
  include Mongoid::Timestamps
  field :reply ,type: String
  field :replyer, type: String
  embedded_in :crlog
end
