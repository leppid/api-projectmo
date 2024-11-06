class ApplicationRecord < ActiveRecord::Base
  include RansackSearchable
  primary_abstract_class
end
