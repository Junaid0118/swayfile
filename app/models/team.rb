class Team < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum role: {
    contract_party: 'contract-party',
    signatory_party: 'signatory-party'
  }
end
