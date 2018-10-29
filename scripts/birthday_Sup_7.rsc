args <- commandArgs(trailingOnly = TRUE)
x<-as.data.frame(read.table(args[1],head=FALSE),sep="\t")
cutoff<-args[2]
bctrl=c()
bcase=c()
decision=c()
for (i in 1:dim(x)[1]){
	ncase<-x[i,6]
	kcase<-x[i,4]
	mcase<-x[i,3]
	nctrl<-x[i,7]
        kctrl<-x[i,5]
        mctrl<-x[i,3]
	bcase[i]<-sprintf("%.2e",pbirthday(ncase,mcase,kcase))
	bctrl[i]<-sprintf("%.2e",pbirthday(nctrl,mctrl,kctrl))
	decision[i]=1
	if(as.numeric(bcase[i])<as.numeric(cutoff)){decision[i]=bcase[i]}
	if(as.numeric(bctrl[i])<as.numeric(cutoff)){decision[i]=1}

}
#write.table(cbind(x,bcase,bctrl,decision),file=paste(args[1],"bday",sep="."),sep="\t",col.names=TRUE,quote=FALSE)
write.table(cbind(x,bcase,bctrl,decision),sep="\t",col.names=TRUE,quote=FALSE)
