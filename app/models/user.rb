# == Schema Information
#
# Table name: users
#
#  id                         :uuid             not null, primary key
#  admin                      :boolean          default(FALSE)
#  announcements_last_read_at :datetime
#  current_sign_in_at         :datetime
#  current_sign_in_ip         :string
#  email                      :string           default(""), not null
#  encrypted_password         :string           default(""), not null
#  first_name                 :string
#  github_link                :string
#  last_name                  :string
#  last_sign_in_at            :datetime
#  last_sign_in_ip            :string
#  remember_created_at        :datetime
#  reset_password_sent_at     :datetime
#  reset_password_token       :string
#  role                       :integer          default("user")
#  sign_in_count              :integer          default(0), not null
#  state                      :integer          default("offline")
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  after_initialize :set_default_role, if: :new_record?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, :trackable

  has_one_attached :avatar
  has_person_name
  has_noticed_notifications

  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :services
  belongs_to :account, optional: true

  # Online/Offline state
  enum state: { 
    offline: 0, 
    online: 1 
  }
# Roles, add other roles as required
  enum role: {
    user: 0,
    member: 1
  }
  
  private 

  def set_default_role
    self.role ||= :user
  end 

# attr_accessor :username, :email, :password, :password_confirmation, :remember_me, :role, :first_name, :last_name, :github_link, :avatar

end
