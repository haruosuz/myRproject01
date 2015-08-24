

# [R でグラフ作成 ggplot2 入門](http://www.cwk.zaq.ne.jp/fkhud708/files/R-ggplo2.pdf)
## 1. イントロ

	#install.packages("ggplot2", dep=T)
	library(ggplot2)
	head(ToothGrowth, n=3)
	str(ToothGrowth)

## 2. ggplot2 事始

	base <- ggplot(ToothGrowth, aes(x=dose, y=len))

	points <- base + geom_point()	plot(points)	base + geom_point() # plot(points) と同じ働き

	?geom_point

	?stat_bin

## 3. グラフの作成例

	base <- ggplot(ToothGrowth, aes(x=dose, y=len))
	base + geom_bar(stat="identity")

	base <- ggplot(ToothGrowth, aes(x=dose, y=len))	base + geom_bar(stat="identity", fill="lightblue", color="red")

	#install.packages("doBy", dep=T)
	library(doBy)
	( MEAN <- summaryBy(len ~ dose, data=ToothGrowth, FUN=c(length,mean,sd)) )

	base2 <- ggplot(MEAN, aes(x=dose, y=len.mean))
	base2 + geom_bar(stat="identity", fill="lightblue", color="red")


	base2 <- ggplot(MEAN, aes(x=dose, y=len.mean))
	base2 + geom_bar(stat="identity", fill="lightblue", color="red") + geom_hline(yintercept=15, color="blue")

	base <- ggplot(ToothGrowth, aes(x=dose, y=len))
	base + geom_point(shape=3, size=2, color="red")

	base <- ggplot(ToothGrowth, aes(x=dose, y=len))
	base + geom_point() + facet_wrap( ~ supp, nrow=1, ncol=2)
	base + geom_point() + facet_grid(. ~ supp) # 上記と同じ

	base <- ggplot(ToothGrowth, aes(x=dose, y=len, color=supp))
	base + geom_point(shape=3, size=2) + stat_smooth(method=lm, se=FALSE) # デフォルト:formula=y~x

	nc <- diff(range(ToothGrowth$len)/nclass.FD(ToothGrowth$len))	base <- ggplot(ToothGrowth, aes(x=len))	base + geom_histogram(binwidth=nc, fill="blue")	base + geom_histogram(binwidth=nc, fill="blue", aes(y=..count..))

	nc <- diff(range(ToothGrowth$len)/nclass.FD(ToothGrowth$len))	base <- ggplot(ToothGrowth, aes(x=len))	base + geom_histogram(binwidth=nc, fill="blue", alpha=0.3)

	nc <- diff(range(ToothGrowth$len)/nclass.FD(ToothGrowth$len))	base <- ggplot(ToothGrowth, aes(x=len))	base + geom_histogram(binwidth=nc, fill="blue", aes(y=..density..)) + geom_density(col="red", fill=NA)

	nc <- diff(range(ToothGrowth$len)/nclass.FD(ToothGrowth$len))
	base <- ggplot(ToothGrowth, aes(x=len))
	base + geom_histogram(binwidth=nc, fill="blue", aes(y = ..density..)) + geom_line(stat="density", col="red") + expand_limits(y=0)

	base <- ggplot(ToothGrowth, aes(x=factor(dose), y=len))	base + geom_boxplot()

	base <- ggplot(ToothGrowth, aes(x=factor(dose), y=len))
	base + geom_boxplot(aes(fill=factor(supp)), outlier.size=2)

	base <- ggplot(data.frame(x = c(-5, 5)), aes(x))	base + stat_function(fun=dnorm)

	f <- function(x) x^3/2
	base <- ggplot(data.frame(x = c(-5, 5)), aes(x))
	base + stat_function(fun=f, color="red")

	xlimit <- function(x) { y <- dnorm(x); y[x<0 | x>2] <- NA; y }
	base <- ggplot(data.frame(x = c(-5, 5)), aes(x))
	base + stat_function(fun=xlimit, geom="area", fill="blue", alpha=0.3) + stat_function(fun=dnorm)

	base <- ggplot(data.frame(x = c(-5, 5)), aes(x))	base + stat_function(fun=dnorm, args=list(mean=2, sd=0.5))

	f <- function(x) x^3/2 ; g <- function(x,y) (x-y)^4/3
	base <- ggplot(data.frame(x = c(-5, 5)), aes(x))
	base + stat_function(fun=f, color="red") + stat_function(fun=g, color="blue", args=list(y=1)) + ylim(c(-40,40))

	TMP1 <- xtabs( ~ dose + supp, data=subset(ToothGrowth,len>=15))
	TMP2 <- prop.table(TMP1, 1)
	( TAB1 <- reshape(as.data.frame(TMP1), v.names="Freq", idvar="supp", varying=list(3), direction="long") )[,-3]
	( TAB2 <- reshape(as.data.frame(TMP2), v.names="Freq", idvar="supp", varying=list(3), direction="long") )[,-3]

	ggplot(TAB1, aes(x=dose, y=Freq, fill=supp)) + geom_bar(position="dodge", stat="identity")
	ggplot(TAB2, aes(x=dose, y=Freq, fill=supp)) + geom_bar(position="dodge", stat="identity")
## 4. グラフのカスタマイズ例

	MEAN <- summaryBy(len ~ dose, data=ToothGrowth, FUN=c(length,mean,sd))
	base3 <- ggplot(MEAN, aes(x=dose, y=len.mean)) + geom_bar(stat="identity", fill="lightblue", color="red")
	base3

	base3 + coord_flip()

	( MEAN <- summaryBy(len ~ dose + supp, data=ToothGrowth, FUN=c(length,mean,sd)) )
	ggplot(MEAN, aes(x=dose, y=len.mean, color=supp)) + geom_errorbar(aes(ymin=len.mean-len.sd, ymax=len.mean+len.sd), width=.1) + geom_line() + geom_point() + ggtitle("Mean Plot")

	pd <- position_dodge(0.1) # 曲線同士が重ならないように少しズラす	ggplot(MEAN, aes(x=dose, y=len.mean, color=supp)) +	geom_errorbar(aes(ymin=len.mean-len.sd, ymax=len.mean+len.sd), width=.1, position=pd) +	geom_line(position=pd) + geom_point(position=pd, size=1.5, shape=7) +	scale_color_manual(values=c("OJ"="red","VC"="blue")) +	scale_color_discrete(limits=c("OJ","VC"), labels=c("OJ"="Orange Juice","VC"="Vitamin C")) +	theme(legend.position=c(0.75,0.0), legend.justification=c(0,0)) +	xlab("Dose") + ylab("Length") + ggtitle("Mean Plot") + labs(color="Supp.") +	xlim(c(0,2.5)) +	scale_y_continuous(limits=c(0,40), breaks=seq(0,40,20), labels=c("0mm","20mm","40mm")) +	annotate("text", x=1, y=11, label="1.0 mg") +
	theme_bw()

	base <- ggplot(ToothGrowth, aes(x=factor(dose), y=len)) + geom_boxplot(aes(fill=factor(supp)), outlier.size=2)	base

	base + theme(axis.title.x=element_blank())

	base + scale_x_discrete(labels=c("0.5 mg","1 mg","2 mg")) + 
	 theme(axis.title.x=element_blank(),
	  axis.text.x=element_text(angle=30, hjust=1, vjust=1,	  face="italic", colour="red", size=12))

