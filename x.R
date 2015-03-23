# cannot get subset to work with select for column names containting space

# I am now highly sceptical about the d = zoo () as I'm not convinced that t and ts are the same size....
library (chron)
library (zoo)
library (ggplot2)
library (reshape2)

cnames = c ("date", "EV", "EA", "EW", "WV", "WA", "WW", "OV", "OA", "OW", "OHz", "Efficiency", "Temp1", "Temp2", "E Day", "E Week", "dunno", "E_month", "E Year", "E Tot1", "E Tot2", "Response")
#t1 = read.table (gzfile ("../logging/output-20131012.gz"), header = F, col.names = cnames, fill=TRUE)
#t1 = read.table (gzfile ("input"), header = F, col.names = cnames, fill=TRUE)
t1 = read.table (gzfile ("../logging/output.gz"), header = F, col.names = cnames, fill=TRUE)

#t = subset (t1, select = c(-Response, -date))
t = subset (t1, select = c(EW, WW, OW, E_month, Efficiency))

ts = as.POSIXlt (t1$date, format= "%Y%m%d-%H:%M:%S")

#t$times = ts

t$fw = as.POSIXlt (ts)$mday
#t$timer = as.POSIXlt (ts)
tod=as.POSIXlt (paste ("2013-01-01", ts$hour, ts$min, ts$sec, sep=":"), format="%Y-%m-%d:%H:%M:%S")

mday=ts$mday

d = as.data.frame (cbind (ts, t, tod, mday), order.by = ts)
#d = zoo (as.matrix (t), order.by = ts)


print (summary (t))

print (summary (ts))

print (summary (d))

byMin = na.omit (aggregate(d, list (as.numeric (d$ts) - as.numeric(d$ts) %% 300), mean, na.action=na.rm))
pdf (file="boxplot.pdf")

print (summary (byMin))

byTenMinMax  = aggregate(d, list (as.numeric (d$ts) - as.numeric(d$ts) %% 60), max)
byTenMinMin  = aggregate(d, list (as.numeric (d$ts) - as.numeric(d$ts) %% 60), min)
byTenMinMean = aggregate(d, list (as.numeric (d$ts) - as.numeric(d$ts) %% 60), mean)

dat = merge (byTenMinMin, byTenMinMax, by = "ts")

readings = melt (byMin, id.vars = c("tod", "mday"), measure.vars = c("OW", "Efficiency"))
print (summary (readings))

byMin$Inverter = factor (cut (byMin$ts, breaks=c (as.POSIXlt ("2011-11-11"), as.POSIXlt("2013-10-18"), as.POSIXlt ("2013-11-08"), as.POSIXlt ("2013-11-25"), as.POSIXlt("2015-11-01"))))
levels (byMin$Inverter) = c("First", "Second", "Third", "Fourth")


# this works, but colours/labels are wrong
#ggplot (byMin) + geom_point ( aes (x=tod, y=as.numeric(WW), colour="red")) + geom_point(aes (x=tod, y=as.numeric (EW), colour="blue")) +geom_point (aes (x=tod, y=as.numeric (OW)))  # + facet_wrap (~ fw)
#ggplot (readings) + geom_point ( aes (x=tod, y=value, colour=variable))  + facet_wrap (~ mday)
#ggplot (byMin) + geom_point ( aes (x=log(OW), y=Efficiency, colour=factor (mday < 18))) #+facet_wrap (~ mday, nrow=1) + ggtitle ("Output by ...")
ggplot (byMin) + geom_boxplot ( aes (Inverter, OW/(WW + EW)), notch=T) +labs (x="Different Inverters", y="Mean Efficiency Integrated over Minute Intervals") #+facet_wrap (~ mday, nrow=1) + ggtitle ("Output by ...")
#autoplot.zoo (d)

#data=d, date, OW)

dev.off()
pdf ("Efficiencies.pdf")
ggplot (byMin) + geom_point ( aes (x=log(OW), y=OW/(WW+EW), colour=Inverter),  alpha=0.2) +labs (x="Log Output Power", y="Efficiency")

dev.off()
