library("rvest")
library("magrittr")

# mainDir: path to folder into which pictures will be downloaded (excl. subDir)
# - make sure to change this to a path that makes sense to you!
mainDir <- "/Users/rodrigo/Documents/2020/Estudos"
# subDir: cartoon name == folder name
subDir <- "peanuts"

dir.create(file.path(mainDir, subDir))
setwd(file.path(mainDir, subDir))

for(yy in 1974:2020){
  yys <- sprintf("%02d", yy)
  for(mm in 1:12){
    
    mms <- sprintf("%02d", mm)
    for(dd in 27:31){
    
      # Added a sample timer that going from 1-10 seconds of delay for the next request (TimeOut)
      #x<-sample(1:10,1)
      #Sys.sleep(x)
      #CONFIGURE TIMER FOR MINIMIZING SERVER ERROR PROBLEMS (500)
      # Some months are only 30 days long. this line takes care of that.
      if(!((mm==2||mm==4||mm==6||mm==9||mm==11)&&(dd==31))) {
        # Add - February 28 days # Rodrigo Conde Attanasio - razow@msn.com
        #mm=2
        #dd=29
        #yy
        if(!((mm==2)&&(dd==30) ||
             !((mm==2)&&(dd==29)&&((yy==1972)||(yy==1976)||(yy==1980)||(yy==1984)||(yy==1988)||(yy==1992)||(yy==1996)||(yy==2000)||(yy==2004)||(yy==2008)||(yy==2012)||(yy==2016)||(yy==2020)||(yy==2024)||(yy==2028))  
             )))
        {
          dds <- sprintf("%02d", dd)
          dest <- paste(subDir, yys, mms, dds, ".png", sep="")
        
          if(!file.exists(dest)) {
          
            pgurl <- paste("http://www.gocomics.com/", subDir, "/",
                           yys, "/", mms, "/", dds, sep = "")
            pghtml <- xml2::read_html(pgurl)
          
            #Changed Nodes - updated also to XML Search using picture AND (.) item-comic-image
            nodes <- html_nodes(x = pghtml, "picture.item-comic-image")
            
            #Using XML Attributes from xml_child nodes[[1]] with [['src']] as attr
            imgsrc <- xml_attrs(xml_child(nodes[[1]], 1))[["src"]]
            
            #Informing process...
            
            message(paste("Downloading ", dest, "...", sep=""))
            download.file(imgsrc, destfile=dest, mode="wb", quiet = T)
            
            #message(paste('Next in: ',x,seconds, sep=''))
          
            #rstudio::viewer(url = dest)
          
          } else {
            message(paste("already exists file: ", dest))
          }        
        }
      }
    }
  }
}
