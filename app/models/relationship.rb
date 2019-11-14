class Relationship < ApplicationRecord
    belongs_to :following, class_name: "EndUser", optional: true
    belongs_to :follower, class_name: "EndUser", optional: true
end
