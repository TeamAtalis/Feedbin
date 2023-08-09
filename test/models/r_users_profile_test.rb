require "test_helper"

class RUsersProfileTest < ActiveSupport::TestCase
  fixtures :r_users_profiles

  def setup
    @aux_rup = RUsersProfile.find(1)
  end

  test "get profile" do
    assert_not_nil @aux_rup
  end

  test "try insert profile with not complet atributes" do
     rup = RUsersProfile.new()
     assert_not rup.save, "Should not save the item without the profile_id and without user_id"
  end

  test "try insert the same profile to the same user" do
    assert_not RUsersProfile.new(user_id: @aux_rup.user_id, profile_id: @aux_rup.profile_id).save, "Should not save because this relation already exists"
  end
end
