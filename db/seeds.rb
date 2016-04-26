# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# insert into users('email', 'password_digest') values('volker', '$2a$10$G9sPxTMLXoGMdu0P346WbOVJmMxvfVMWySHt.M/AGzjVhpOvbZp9S');
User.create(email: "volker", password_digest: "$2a$10$G9sPxTMLXoGMdu0P346WbOVJmMxvfVMWySHt.M/AGzjVhpOvbZp9S")