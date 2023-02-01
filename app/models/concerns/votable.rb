module Votable
  extend ActiveSupport::Concern

  included do
    # Check if account has voted for votable and return bool
    def account_voted?(account)
      votes.pluck(:account_id).include?(account.id)
    end

    # Reddit Hot Ranking Algorithm
    # Adapted from https://medium.com/hacking-and-gonzo/how-reddit-ranking-algorithms-work-ef111e33d0d9#:~:text=Reddit's%20hot%20ranking%20uses%20the,as%20the%20next%201000%20etc%E2%80%A6
    def hot_rank
      order = Math.log([cached_score.abs, 1].max, 10)
      sign = cached_score.positive? ? 1 : 0

      # Calculate difference between epoch_seconds and unix timestamp for January 1, 2023
      # Unix timestamp is somewhat arbitrary, no votables should be older than January 1, 2023
      # and subtracting helps to simplify the calculation
      seconds = epoch_seconds - 1_672_531_200

      # The 90_000 number is the number of seconds in 25 hours, used to set boundary for log
      # Votable would need 10 times as much score to be considered as hot as something 25 hours younger
      (sign * order + seconds / 90_000).round(7)
    end

    private

    # Calculate difference in seconds between created_at date and epoch time
    def epoch_seconds
      (created_at - DateTime.new(1970, 1, 1)).to_i
    end
  end
end
