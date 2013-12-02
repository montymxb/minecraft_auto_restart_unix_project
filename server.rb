#!/usr/bin/env ruby
require 'parseconfig.rb'
CONFIG = ParseConfig.new('properties.cfg')
CONFIG.get_params()
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
	Dir.mkdir(d) unless Dir.exist?(d)
	Dir.chdir(d)
	while (Dir['*.tar.gz'].count >= CONFIG['maxBackups'].to_i) do
		oldest = Dir['*.tar.gz'].sort_by{ |f| File.mtime(f) }[0]
		File.delete(oldest)
		puts "Deleted #{CONFIG['backupDirectory']}/#{oldest}"
	end
	Dir.chdir('..')
	time = Time.now.strftime('%d-%b-%y %H:%M:%S')
	`tar -zcvf "#{CONFIG['backupDirectory']}/#{time}.tar.gz" #{@world}`
	puts "Backed #{@world}/ up to #{CONFIG['backupDirectory']}/#{time}.tar.gz"
end

def sendCommand(command)
	prefix = "screen -S minecraftServer -X"
	`#{prefix} stuff "#{command}"`
	`#{prefix} eval "stuff \015"`
end

def serverSession()
	tick = 0
	maxTick = 60 * CONFIG['cycles'].to_i
	while (tick <= maxTick) do
		case tick
		when 1
			sendCommand("say #{CONFIG['text1']}")
		when 2
			sendCommand("say #{CONFIG['text2']}")
		when 3
			sendCommand("say #{CONFIG['text3']}")
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
		tick=tick+1
		sleep 60 unless tick > maxTick
	end
end

while @restart==true do

	@restart=false

	backUp(CONFIG['backupDirectory'])

	puts "Starting server in #{CONFIG['postBackup']} seconds..."
	sleep CONFIG['postBackup'].to_i

	session = Thread.new {serverSession()}
	sleep 3

	server = Process.spawn("screen -S minecraftServer java -Xmx1024m -Xms1024m -jar #{CONFIG['minecraftJarName']} nogui")
	Process.wait(server)

	session.kill
	`screen -ls | grep "minecraftServer" | awk '{print $1}' | xargs -r -i -n1 screen -X -S {} quit`
end