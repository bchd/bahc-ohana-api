task remove_test_users_and_admins: :environment do
  User.
    where(email: %w[user@example.com user2@example.com]).destroy_all

  Admin.
    where(email: %w[ohana@samaritanhouse.com ohana@gmail.com masteradmin@ohanapi.org]).
    destroy_all
end
