#!/usr/bin/ruby

$team_num    = 2 
$probrem_num = 5 
$iteration_num = 10
$tick = 1 / $iteration_num.to_f

$teams = []

class Server
	def initialize(num)
		@num        = num
		@up         = false
		@vulnerable = true
	end

	def up?
		up
	end

	def vulnerable?
		vulnerable
	end

	def next_state
	end

	def to_s
		str =  "s#{@num}:"

		if @up == true
			str << "u"
		else
			str << "d"
		end

		if @vulnerable == true
			str << "v"
		else
			str << "f"
		end

		str
	end

	attr_accessor :num, :up, :vulnerable
end

class Problem
	# status : none -> analized -> (defence, exploit, dos)
	NONE        = 0
	ANALIZED    = 1
	CAN_DEFENCE = 2
	CAN_DOS     = 4
	CAN_EXPLOIT = 8

	def initialize(num)
		@num         = num
		@difficulty  = 0.0 + (num/$probrem_num.to_f) * 1.0 #0.3-0.9
		@progress    = 0
		@status       = NONE
		@next_status  = NONE
	end

	def analized?
		@status & ANALIZED != 0 
	end

	def can_defence?
		@status & CAN_DEFENCE != 0
	end

	def can_exploit?
		@status & CAN_EXPLOIT != 0
	end

	def can_dos?
		@status & CAN_DOS != 0
	end

	def solve(solve_power)
		@progress += $tick * solve_power 

		if !analized?
			if @progress >= @difficulty * 0.5
				@next_status = ANALIZED
			end
		elsif !can_defence?
			if @progress >= @difficulty * 0.6
				@next_status = CAN_DEFENCE
			end
		elsif !can_dos?
			if @progress >= @difficulty * 0.8
				@next_status = CAN_DOS
			end
		elsif !can_exploit?
			if @progress >= @difficulty * 1.0
				@next_status = CAN_EXPLOIT
			end
		else
			#nothing to do...
		end
	end

	def next_state
		@status |= @next_status
		@next_status = NONE
	end

	def to_s
		str = "p#{@num}:"

		str << "#{sprintf("(%.2f, %.2f)", @difficulty, @progress)}"

		str << "a" if analized?
		str << "d" if can_defence?
		str << "D" if can_dos?
		str << "e" if can_exploit?

		str
	end
end

class Team
	def initialize(num, solve_power, network_power)
		@num               = num
		@solve_power       = solve_power    # 0.0 - 1.0
		@network_power     = network_power  # 0.0 - 1.0

		# scores
		@steal_key_num     = 0
		@overwrite_key_num = 0
		@total_sla         = 0

		# challenges status
		@problems = []
		$probrem_num.times {|i|
			@problems << Problem.new(i)
		}

		# challenges servers
		@servers = []
		$probrem_num.times {|i|
			@servers << Server.new(i)
		}
	end

	def manage_servers
	end

	def solve
		@problems.each {|p|
			p.solve(@solve_power)
		}
	end

	def attack
		@problems.each_with_index{|p, i|
		}
	end

	def action
		manage_servers
		solve
		attack
	end
	
	def next_state
		@problems.each {|p|
			p.next_state
		}
		@servers.each {|s|
			s.next_state
		}
	end

	def to_s
		str = "team#{@num} : steal_key_num=#{@steal_key_num}, overwrite_key_num=#{@overwrite_key_num}, total_sla=#{@total_sla}\n  "
		@problems.each {|s|
			str << s.to_s << ", "
		}
		str << "\n  "
		@servers.each {|s|
			str << s.to_s << ", "
		}
		str
	end

	attr_accessor :solv_power, :network_power, :problems, :servers, :steal_key_num, :overwrite_key_num, :total_sla
end

def setup_teams
	# test...
	$team_num.times {|n|
		$teams << Team.new(n, 0.5, 0.5)
	}
end

def simulation_loop

	$iteration_num.times {|n|
		# for debug
		puts "================ iteration=#{n} ================"
		$teams.each {|t|
			puts t.to_s
		}

		(0...$teams.size).to_a.shuffle.each {|i|
			$teams[i].action
		}

		$teams.each {|t|
			t.next_state
		}
	}
	puts "================ final state ================"
	$teams.each {|t|
		puts t.to_s
	}
end

def main
	setup_teams
	simulation_loop
end

main
