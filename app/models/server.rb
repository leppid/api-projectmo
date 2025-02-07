class Server < ApplicationRecord
  before_validation :validate_duplicate, on: :create

  def self.init
    if Server.count == 0
      Server.create!
    else
      Server.first
    end
  end

  def self.open
    Server.first&.update_column(:open, true)
  end

  def self.close
    Server.first&.update_column(:open, false)
  end

  def self.open?
    Server.first&.open
  end

  def self.closed?
    !open?
  end

  private

  def validate_duplicate
    errors.add(:server, 'already exists') if Server.count > 0
  end
end
