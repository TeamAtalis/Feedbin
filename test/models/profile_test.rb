require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  fixtures :profiles

  def setup
    @user = User.find_by(email: 'ann@example.com')
    @tag = Tag.find(1)
    @new_profile = Profile.new(
      profile_name: "Doctor", 
      created_at: Time.now, 
      updated_at: Time.now
    )
    @new_profile.save
  end

  test "connect new tag to profile" do
    assert_empty @new_profile.tags, "Should be empty, is a new profile"
    @new_profile.assign_profile_to_tag(@tag.id, @user.id)
    assert_equal 1, @new_profile.tags.size, "Should be one"
  end

  test "try insert the same tag to the same profile" do
     assert @new_profile.assign_profile_to_tag(@tag.id, @user.id), "Should work"
    assert_raises("") do
      @new_profile.assign_profile_to_tag(@tag.id, @user.id)
    end
  end
end
