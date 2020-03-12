### install steps
1. clone the repo
2. move omnet and research folder to the home direction
3. compile omnet using following link:https://doc.omnetpp.org/omnetpp/InstallGuide.pdf
    (for ubuntu)
    - export PATH=$PATH:$HOME/omnetpp-4.6/bin
    - NO_TCL=1 ./configure
    - make
4. build the homatransport 
    - export LC_ALL="en_US.UTF-8"
    - copy the makefile to homatransport:  
 https://raw.githubusercontent.com/Stanley131/Research_PBS_HOMA/master/OMNet%2B%2B_HOMA/RpcTransportDesign/OMNeT%2B%2BSimulation/homatransport/Makefile_old
    - build inet and homatransport using: make makefiles; make mode=RELEASE
    
