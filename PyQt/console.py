from ftplib import FTP

class Console:
    blocks=0
    def __init__(self,name):
        self._name = name

    def GetFile(self,path,file):
        ftp=FTP(self._name)
        ftp.login()
        ftp.cwd(path)
        # print(ftp.retrlines('LIST'))
        Console.blocks=0
        Console.binfile = open(file,'wb')
        ftp.retrbinary("RETR %s" % file , self.BlockTransferred , 1000 )
        self.binfile.close()
        ftp.quit()

    @staticmethod
    def BlockTransferred(blk):
        Console.blocks += 1
        Console.binfile.write(blk)
        print("Block " , Console.blocks)

if __name__ == "__main__":
    server=Console('ftp.gnu.org')
    server.GetFile('gnu/aspell/dict/en','aspell6-en-6.0-0.tar.bz2')