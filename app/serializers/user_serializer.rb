class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :archived, :deleted

  attribute :user_updates do |user|
    activities = []
    user.versions.each do |v|
      changes = PaperTrail.serializer.load(v.object)
      activities << {
        modifier: User.find(v.whodunnit).email,
        action: v.event,
        changes: changes.slice('id', 'email', 'archived', 'deleted')
      }
    end
    activities
  end
end
