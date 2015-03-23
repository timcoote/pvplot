require 'rake/clean'
require 'date'

CLEAN.include("../logging/georgesdata*")
CLOBBER.include ("../logging/output")

#startDate = Date.parse('2013-10-11')
startDate = Date.parse('2015-02-01')

task :default do |t|
    sh "rsync -av pluto:pvi/aurora-1.7.8d/output-* ../logging"
end

desc 'get the data to show the efficiency of the inverter by day'
task :get_output_for_juliet do |t|
    logdates = 15.upto(25)
    logdates.each do |d|
        sh "gunzip -c ../logging/output-201310#{d}.gz >> ../logging/output"
    end
    sh "gzip ../logging/output"
end

desc "gzip up files"
task :zip_files do |t|
    sh "ls ../logging/output* | grep -v .gz | xargs gzip"
end

desc "get days from the start into one file, eliminating incomplete records"
task :get_recent_output do |t|
    logdates = startDate.upto(Date.today()-2)
    logdates.each do |d|
        d1 = d.strftime("%Y%m%d")
        puts (d1)
        sh "gunzip -c ../logging/output-#{d1}.gz |tr '\\0' '\\n' |grep OK >> ../logging/output"
    end
    sh "gzip ../logging/output"
end

    
desc "get the data used by George's Geography project"
task :get_georges_data do |g|
    logdates = 15.upto(19)
    logdates.each do |d|
# cannot simply do this in one pass, although it ought to be easy. the simple approach runs multiple passes
        sh "gunzip -c ../logging/output-201310#{d}.gz  >> ../logging/georgesdata"
    end
    sh "gzip ../logging/georgesdata"
end
