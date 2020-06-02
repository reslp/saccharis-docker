FROM ubuntu:18.04
MAINTAINER <philipp.resl@uni-graz.at>

RUN apt-get update && \
	apt-get install -y build-essential libwww-perl bioperl cpanminus wget fasttree git hmmer
RUN cpanm threads Bio::Seq Bio::SeqIO Date::Calc File::chdir Getopt::Long HTML::TagParser List::Util LWP::Simple Switch
RUN cpanm URI::Fetch --force

#Prottest
RUN wget https://github.com/ddarriba/prottest3/releases/download/3.4.2-release/prottest-3.4.2-20160508.tar.gz && \
	tar xvfz prottest-3.4.2-20160508.tar.gz && \
	mv prottest-3.4.2 /usr/local/prottest3 && \
	mv /usr/local/prottest3/prottest-3.4.2.jar /usr/local/prottest3/prottest3.jar && \
	rm prottest-3.4.2-20160508.tar.gz

RUN sed -i -e '0,/bless $self, $package;/s//bless $self, ref($package) || $package;/' /usr/local/share/perl/5.26.1/HTML/TagParser.pm

#RUN git clone https://github.com/DallasThomas/SACCHARIS && \
RUN git clone https://github.com/reslp/SACCHARIS && \
	cp SACCHARIS/*.pl /usr/local/bin && \
	chmod +x /usr/local/bin/*.pl && \
	rm /usr/local/bin/cazy_extract.pl

RUN mkdir /usr/local/dbcan && \
	cd /usr/local/dbcan && \
	wget http://bcb.unl.edu/dbCAN2/download/Databases/dbCAN-old@UGA/dbCAN-fam-HMMs.txt && \
	wget http://bcb.unl.edu/dbCAN2/download/Databases/dbCAN-old@UGA/hmmscan-parser.sh && \
	chmod +x hmmscan-parser.sh
	
RUN cd /usr/local/dbcan && \
	hmmpress dbCAN-fam-HMMs.txt
RUN apt-get install -y default-jre parallel

RUN wget https://github.com/stamatak/standard-RAxML/archive/v8.2.12.tar.gz && \
	tar xvfz v8.2.12.tar.gz && \
	cd standard-RAxML-8.2.12/ && \
 	make -f Makefile.SSE3.PTHREADS.gcc && \
 	rm *.o && \
 	make -f Makefile.gcc && \
 	rm *.o && \
	make -f Makefile.AVX.PTHREADS.gcc && \
	rm *.o && \
	mv raxmlHPC /usr/bin && \
	mv raxmlHPC-PTHREADS-AVX /usr/bin && \
	mv raxmlHPC-PTHREADS-SSE3 /usr/bin
	
#this is were the directory containing the custom extract_cazy.pl shall be mounted
RUN mkdir /usr/local/external

ENV PATH="/usr/local/external:$PATH"


CMD ["Saccharis.pl"]

