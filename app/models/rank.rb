class Rank
  attr_reader :upvotes, :downvotes, :created_at

  def initialize(upvotes:, downvotes:, created_at:)
    @upvotes = upvotes
    @downvotes = downvotes
    @created_at = created_at
  end

  def score
    upvotes - downvotes
  end

  # Reddit Hot Ranking Algorithm
  # Adapted from https://medium.com/hacking-and-gonzo/how-reddit-ranking-algorithms-work-ef111e33d0d9#:~:text=Reddit's%20hot%20ranking%20uses%20the,as%20the%20next%201000%20etc%E2%80%A6
  def hot_rank
    order = Math.log([score.abs, 1].max, 10)
    sign = score.positive? ? 1 : 0

    # Calculate difference between epoch_seconds and unix timestamp for January 1, 2023
    # Unix timestamp is somewhat arbitrary, no votables should be older than January 1, 2023
    # and subtracting helps to simplify the calculation
    seconds = epoch_seconds - 1_672_531_200

    # The 90_000 number is the number of seconds in 25 hours, used to set boundary for log
    # Votable would need 10 times as much score to be considered as hot as something 25 hours younger
    (sign * order + seconds / 90_000).round(7)
  end

  # Reddit Best Ranking Algorithm (Wilson Score)
  # Adapted from https://medium.com/hacking-and-gonzo/how-reddit-ranking-algorithms-work-ef111e33d0d9#:~:text=Reddit's%20hot%20ranking%20uses%20the,as%20the%20next%201000%20etc%E2%80%A6
  def confidence_score
    n = upvotes + downvotes
    return 0 if (upvotes - downvotes).zero? || n.zero?

    z_value = 1.281551565545
    positives = upvotes.to_f / n

    left = positives + 1 / (2 * n) * z_value * z_value
    right = z_value * Math.sqrt(positives * (1 - positives) / n + z_value * z_value / (4 * n * n))
    under = 1 + 1 / n * z_value * z_value

    (left - right) / under
  end

  private

  # Calculate difference in seconds between created_at date and epoch time
  def epoch_seconds
    (created_at - DateTime.new(1970, 1, 1)).to_i
  end
end
