class Color < ApplicationRecord
  has_many :types,:dependent => :destroy
end
