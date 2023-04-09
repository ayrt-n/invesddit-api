json.id community.id
json.title community.title
json.sub_dir community.sub_dir
json.description community.description
json.memberships_count community.members_count
json.created_at community.created_at
json.avatar community.avatar.attached? ? rails_blob_url(community.avatar) : nil
json.banner community.banner.attached? ? rails_blob_url(community.banner) : nil
