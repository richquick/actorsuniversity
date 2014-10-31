module FormBacker
  extend ActiveSupport::Concern

  included do
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
  end
end
