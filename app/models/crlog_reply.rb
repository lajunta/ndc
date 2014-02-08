# -*- encoding : utf-8 -*-
class CrlogReply
  include Mongoid::Document
  include Mongoid::Timestamps
  field :reply ,type: String
  field :replyer, type: String
  embedded_in :crlog
  index({replyer: 1})
  index({created_at: 1})
end
