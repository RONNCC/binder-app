# ## Schema Information
#
# Table name: `faqs`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`answer`**      | `text(65535)`      |
# **`created_at`**  | `datetime`         |
# **`id`**          | `integer`          | `not null, primary key`
# **`question`**    | `text(65535)`      |
# **`updated_at`**  | `datetime`         |
#

class Faq < ActiveRecord::Base
  # attr_accessible :answer, :question
  scope :search, lambda { |term| where('lower(question) LIKE lower(?) OR lower(answer) LIKE lower(?)', "%#{term}%", "%#{term}%") }

end
