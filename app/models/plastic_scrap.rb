class PlasticScrap < ApplicationRecord
  belongs_to :party
  belongs_to :type
  enum labour: [:"Outside Labour",:"Factory Labour"]
end
