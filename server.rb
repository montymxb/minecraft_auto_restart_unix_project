#!/usr/bin/env ruby
load 'properties.cfg'
@restart=true
$stderr.reopen("error.log", "w")
#$stdout.reopen("devlog.log", "w")

def backUp(d)
	mconfig = File.new('server.properties')
	mconfig.each_line { |line|
	  if line =~ /level-name.*/ then
	    @world = line.split('level-name=')[1].chomp!
	  end
	}
	unless defined? @world
		puts "Error: level-name not found (check your server.properties or error.log)" 
		return;
	end
	Dir.mkdir(d) unless File.directory?(d) ##Dir.exist?(d) not available on 1.8.7 (most Macs)
	Dir.chdir(d)
	while (Dir['*.tar.gz'].count >= MAXBACKUPS) do
		oldest = Dir['*.tar.gz'].sort_by{ |f| File.mtime(f) }[0]
		File.delete(oldest)
		puts "Deleted #{BACKUPDIRECTORY}/#{oldest}"
	end
	Dir.chdir('..')
	time = Time.now.strftime('%d-%b-%y %H:%M:%S')
	`tar -zcvf "#{BACKUPDIRECTORY}/#{time}.tar.gz" #{@world}`
	puts "Backed #{@world}/ up to #{BACKUPDIRECTORY}/#{time}.tar.gz"
end

def sendCommand(command)
	prefix = "screen -S minecraftServer -X"
	`#{prefix} stuff "#{command}"`
	`#{prefix} eval "stuff \015"`
end

def serverSession()
	tick = 0
	maxTick = 60 * CYCLES
	while (tick <= maxTick) do
		case tick
		when maxTick-10
			sendCommand('say Server will be restarting in 10 minutes.')
		when maxTick-5
			sendCommand('say Server will be restarting in 5 minutes.')
		when maxTick-1
			sendCommand('say Server will be restarting in 1 minute.')
		when maxTick
			sendCommand('say Server is restarting now,')
			sleep 3
			@restart=true;
			sendCommand('stop')
		end
		if ((tick%60 == 0) && (tick != 0) && (tick != maxTick))
			sendCommand("say Server has been up for #{tick/60} hours")
		end
		if (MESSAGES.has_key?(tick))
			sendCommand("say #{MESSAGES[tick]}")
		end
		tick=tick+1
		sleep 60 unless tick > maxTick
	end
end

while @restart==true do

	@restart=false

	backUp(BACKUPDIRECTORY)

	puts "Starting server in #{POSTBACKUP} seconds..."
	sleep POSTBACKUP

	session = Thread.new {serverSession()}
	sleep 3

	###server = Process.spawn("screen -S minecraftServer java -Xmx1024m -Xms1024m -jar #{MINECRAFTJARNAME} nogui")
	##not Process.spawn not available on 1.8.7
	
	server = fork do
		`screen -S minecraftServer java -Xmx1024m -Xms1024m -jar #{MINECRAFTJARNAME} nogui`
	end
	
	Process.detach(server)
	
	Process.wait(server)

	session.kill
	`screen -ls | grep "minecraftServer" | awk '{print $1}' | xargs -r -i -n1 screen -X -S {} quit`
end