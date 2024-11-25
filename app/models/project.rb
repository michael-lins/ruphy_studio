class Project < ApplicationRecord
  has_many :components, dependent: :destroy
  validates :name, presence: true
end
