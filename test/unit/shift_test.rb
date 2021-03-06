# ## Schema Information
#
# Table name: `shifts`
#
# ### Columns
#
# Name                                   | Type               | Attributes
# -------------------------------------- | ------------------ | ---------------------------
# **`created_at`**                       | `datetime`         |
# **`description`**                      | `string(255)`      |
# **`ends_at`**                          | `datetime`         |
# **`id`**                               | `integer`          | `not null, primary key`
# **`organization_id`**                  | `integer`          |
# **`required_number_of_participants`**  | `integer`          |
# **`shift_type_id`**                    | `integer`          |
# **`starts_at`**                        | `datetime`         |
# **`updated_at`**                       | `datetime`         |
#
# ### Indexes
#
# * `index_shifts_on_organization_id`:
#     * **`organization_id`**
#

require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  # Relationships
  should belong_to(:organization)
  should have_many(:participants).through(:shift_participants)
  should have_many(:shift_participants)
  should belong_to(:shift_type)

  # Validations
  #does not need to have an organization
  should validate_presence_of(:starts_at)
  should validate_presence_of(:ends_at)
  should validate_presence_of(:required_number_of_participants)

  context "With a proper context, " do
    setup do
      # Create 3 shifts
      @upcomming = FactoryGirl.create(:shift, :ends_at => Time.local(2021,1,1,15,0,0), :starts_at => Time.now + 1.hour)
      @current = FactoryGirl.create(:shift, :ends_at => Time.local(2020,1,1,15,0,0), :starts_at => Time.local(2014,1,1,13,4,0))
      @past = FactoryGirl.create(:shift, :ends_at => Time.local(2001,1,1,15,0,0), :starts_at => Time.local(2000,1,1,14,10,0))
      @not_checked_in = FactoryGirl.create(:shift, :required_number_of_participants => 1 )
      @checked_in = FactoryGirl.create(:shift, :required_number_of_participants => 2)
      FactoryGirl.create(:shift_participant, :shift => @checked_in)
      FactoryGirl.create(:shift_participant, :shift => @checked_in)
    end

    teardown do
    end

    should "show that all factories are properly created" do
      assert_equal 5, Shift.all.size
    end

    # Scopes
    should "have a scope 'current' that works" do
      assert_equal 1, Shift.current.size
    end

    should "have a scope 'upcoming' that works" do
      assert_equal 1, Shift.upcoming.size
    end

    # Methods

    should "have a method 'is_checked_in' that works" do
      assert_equal true, @checked_in.is_checked_in
      assert_equal false, @not_checked_in.is_checked_in
    end
  end
end
