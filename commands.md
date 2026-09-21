#install dependencies
packer init .

#check syntax
packer validate .

#check format
packer fmt .

#build ami 
packer build .