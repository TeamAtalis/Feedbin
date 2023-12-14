################
On Rails console:

user = User.find_by(email: "admin@gmail.com")
user.save

#That way we are putting the admin as our current user
import = Import.new
import.user = User.find_by(email: "marc@gmail.com")

import.xml = File.read('marc_feed.opml')

import.parse



import = Import.new
#<Import:0x0000000111d2bce0 id: nil, user_id: nil, complete: false, created_at: nil, updated_at: nil, upload: nil, filename...

import.user = User.find_by(email: "marc@gmail.com")
  User Load (0.9ms)  SELECT "users".* FROM "users" WHERE "users"."email" = $1 LIMIT $2  [["email", "marc@gmail.com"], ["LIMIT", 1]]
#<User:0x0000000115756410
...
import.xml = File.read('marc_feed.opml')
"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\n<opml version=\"1.0\">\n    <head>\n        <title>Atalis subscriptions in f..."

import.parse
  Tag Load (0.7ms)  SELECT "tags".* FROM "tags" WHERE "tags"."name" = $1 ORDER BY "tags"."id" ASC LIMIT $2  [["name", "MARC 2"], ["LIMIT", 1]]
nil 