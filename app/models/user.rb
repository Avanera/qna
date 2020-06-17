class User < ApplicationRecord
  has_many :questions
  has_many :answers

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(record)
    self.id == record.user_id
  end
end
