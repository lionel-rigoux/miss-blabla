# == Schema Information
#
# Table name: agents
#
#  id         :integer          not null, primary key
#  nom        :string(255)
#  email      :text
#  telephone  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Agent < ActiveRecord::Base

  # relations
  has_many :clients
  has_one :patron

  # validations
  validates_presence_of :nom, :email, :telephone
  validates_uniqueness_of :nom
  validates :email, email: true
  validates_format_of :telephone, :with => /[0-9]{10}/
  before_validation :format_phone
  def format_phone
    self.telephone = (self.telephone || "").gsub(/[^\d]/,'')
  end

end
