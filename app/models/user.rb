class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_tenant
 
  def full_name
    first_name.titleize + ' ' + last_name.titleize
  end

  private
  def create_tenant
    Apartment::Tenant.create(subdomain)   
  end 
end