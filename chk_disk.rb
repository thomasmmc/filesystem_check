require 'sys/filesystem'
include Sys
require 'socket'

#Class for calculating percents
class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end

#Get the host name
hostname = Socket.gethostname

#Get the mounts we are working with
mounts = Filesystem.mounts

#Setup our results array
results = []

#Goign thru each mount point and gathering filesystem stats
mounts.each do |mount|

stat = Filesystem.stat("#{mount.mount_point}")
#Building varialbes
mb_available = stat.block_size * stat.blocks_available / 1024 / 1024
percent = stat.blocks_available.percent_of(stat.blocks)
percent = percent.round(1)

path = stat.path
#if the percent is greater then 10% then we don't need to alert
 if percent <= 10
  details = {path: path, mb_available: mb_available, percent: percent} 
  #adding our hash into the results array
  results << details
 else
 end
end

#If we have any results then we are going to need to send an alert
if results.any?
@info = ''
results.each do |result|
@info << "Path #{result[:path]}\n #{result[:mb_available]}MB\n #{result[:percent]}%\n"
 end
#Setting some email variables
@recipients = ['you@email.com']
@subject =  "Disk Space is running low on #{hostname}"
@body = "Appears we are running low on disk space on #{hostname}\n #{@info}" 
#Loading a preexsting script for sending alerts 
load 'send_alert_mail.rb'
else
end

