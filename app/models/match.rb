class Match < ApplicationRecord
    has_many :games
    has_many :games, dependent: :destroy
end
