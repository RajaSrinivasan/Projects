#include <stdio.h>
#include <time.h>
#include <sys/time.h>

void GetClock(struct timeval *tv)
{
    gettimeofday(tv,NULL) ;
}

char *Printable(struct timeval *tv)
{
  static char timeImage[32];
  struct tm *now ;
  int written ;
  now=localtime(&tv->tv_sec) ;
  if (NULL != now)
  {
      written = strftime(timeImage, sizeof(timeImage) , "%Y-%m-%d %H:%M:%S", now ) ;
      snprintf(&timeImage[written],sizeof(timeImage)-written,".%03d",tv->tv_usec/1000 ) ;
  }
  else
  {
      timeImage[0] = '\0' ;
  }
  return timeImage ;
}
