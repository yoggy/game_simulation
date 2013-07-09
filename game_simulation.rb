#!/usr/bin/ruby

$teams = []

class Server
end

class Problem
end

class Team
	def initialize()
	end

	def action
	end
	
	def next_state
	end
end

def setup_teams
	t = Team.new()
	$teams << t
end

def simulation_loop
	100.times {|n|
		# 問題を解く
		$teams.each {|t|
			t.action
		}

		# サーバ、問題を次の状態へ遷移
		$teams.each {|t|
			t.next_state
		}
	}
end

def main
	setup_teams
	simulation_loop
end

main
