module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = find_verified_player
      logger.add_tags 'ActionCable', current_player.email
    end

    private

    def find_verified_player
      verified_player = Player.find_by(id: cookies.signed['player.id'])
      if verified_player && cookies.signed['player.expires_at'] > Time.now
        verified_player
      else
        reject_unauthorized_connection
      end
    end
  end
end
