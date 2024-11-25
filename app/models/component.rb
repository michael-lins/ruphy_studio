class Component < ApplicationRecord
  belongs_to :project
  validates :component_type, presence: true
end

