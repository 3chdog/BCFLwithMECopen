# /*******************************************************
#  * Author:
#  * LukeHu <lukehu.nctu@gmail.com>
#  *******************************************************/

import subprocess
import tarfile
import os.path
import os

def ipfsGetFile(hashValue, fileName):
    """
    Use hashValue to download the file from IPFS network.
    """
    ipfsGet = subprocess.Popen(args=['ipfs get ' + hashValue + ' -o ' + fileName], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8')
    outs, errs = ipfsGet.communicate(timeout=10)
    if ipfsGet.poll() == 0:
        return outs.strip(), ipfsGet.poll()
    else:
        return errs.strip(), ipfsGet.poll()

def ipfsCatFile(hashValue):
    """
    Use hashValue to download the file from IPFS network.
    """
    ipfsGet = subprocess.Popen(args=['ipfs cat ' + hashValue], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8')
    outs, errs = ipfsGet.communicate(timeout=10)
    if ipfsGet.poll() == 0:
        return outs.strip(), ipfsGet.poll()
    else:
        return errs.strip(), ipfsGet.poll()

def ipfsAddFile(fileName):
    """
    Upload the file to IPFS network and return the exclusive fileHash value.
    """
    ipfsAdd = subprocess.Popen(args=['ipfs add ' + fileName + ' | tr \' \' \'\\n\' | grep Qm'], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8')
    outs, errs = ipfsAdd.communicate(timeout=10)
    if ipfsAdd.poll() == 0:
        return outs.strip(), ipfsAdd.poll()
    else:
        return errs.strip(), ipfsAdd.poll()


def tarFile(source_dir, output_filename):
    with tarfile.open(output_filename, "w:gz") as tar:
        tar.add(source_dir, arcname=os.path.basename(source_dir))        

def untarFile(fileName, output_path):
    file = tarfile.open(fileName)
    file.extractall(output_path)
    file.close()

def delFile(fileName):
    if os.path.exists(fileName):
        os.remove(fileName)
    else:
        print("The file does not exist!")

#unitest
""" if __name__ == '__main__':
    checkpoint_path = "./training"
    tarFile(checkpoint_path, 'input.tar.gz')    

    hash = ipfsAddFile('./input.tar.gz')
    delFile('./input.tar.gz')
    print(hash[0])

    ipfsGetFile(hash[0], 'output.tar.gz')
    untarFile('output.tar.gz', './untar')
    delFile('output.tar.gz') """
    
