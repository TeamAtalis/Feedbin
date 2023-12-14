Profile.create!(profile_name: "Biotech")
Profile.create!(profile_name: "Cancer")
Profile.create!(profile_name: "Motor")

Tag.create!(name: "Biomaterials")
Tag.create!(name: "Stem Cell")
Tag.create!(name: "Nanobiotechnology")


Tag.create!(name: "Cancer Advances")
Tag.create!(name: "Prostate")
Tag.create!(name: "Breast Cancer")

Tag.create!(name: "Formula 1")
Tag.create!(name: "Le Mans")
Tag.create!(name: "GT")

biotech_id = Profile.find_by(profile_name: "Biotech").id

RUsersProfile.create!(user_id: 1, profile_id: biotech_id)

RProfilesTag.create!(profile_id: biotech_id, tag_id: Tag.find_by(name: "Biomaterials").id)
RProfilesTag.create!(profile_id: biotech_id, tag_id: Tag.find_by(name: "Stem Cell").id)
RProfilesTag.create!(profile_id: biotech_id, tag_id: Tag.find_by(name: "Nanobiotechnology").id)


cancer_id = Profile.find_by(profile_name: "Cancer").id

RUsersProfile.create!(user_id: 1, profile_id: cancer_id)

RProfilesTag.create!(profile_id: cancer_id, tag_id: Tag.find_by(name: "Cancer Advances").id)
RProfilesTag.create!(profile_id: cancer_id, tag_id: Tag.find_by(name: "Prostate Cancer").id)
RProfilesTag.create!(profile_id: cancer_id, tag_id: Tag.find_by(name: "Breast Cancer").id)

motor_id = Profile.find_by(profile_name: "Motor").id

RUsersProfile.create!(user_id: 1, profile_id: motor_id)

RProfilesTag.create!(profile_id: motor_id, tag_id: Tag.find_by(name: "Formula 1").id)
RProfilesTag.create!(profile_id: motor_id, tag_id: Tag.find_by(name: "Le Mans").id)
RProfilesTag.create!(profile_id: motor_id, tag_id: Tag.find_by(name: "GT").id)