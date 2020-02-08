/src/application/MsgSizeDistributions.cc:
    sizeDistSelector: the selector for the workload

adding new data sets:
    https://github.com/PlatformLab/HomaSimulation/commit/93bb0da45a4377e2cb0fdc5caa8160a061cff411

bytes transmitted
    this function returns the actual bytes transmitted on the wire
    RpcTransportDesign/OMNeT++Simulation/homatransport/src/transport/HomaPkt.cc
    HomaPkt::getBytesOnWire

arrival time (oracle scheduler?)
    https://github.com/PlatformLab/HomaSimulation/commit/d96bfe0e0ffb0a24595c8d43b46d6afc540f99a4

initial setting up for priority
    https://github.com/PlatformLab/HomaSimulation/commit/5127d8d028251aac79879a4a0e09bc89bc3035cf


HomaTransport.cc
/**
 * This method is a virtual method defined for every simple module in omnet++
 * simulator. OMNeT++ core simulator automatically calles this function at the
 * early stage of the simulator, after simulation objects are constructed and as
 * a part of the steps for the simlation setup.
 */
void
HomaTransport::initialize() 
// Read in config parameters for HomaTransport from config files and store
    // the parameters in a depot container.
    homaConfig = new HomaConfigDepot(this);

HomaSimulation/RpcTransportDesign/OMNeT++Simulation/homatransport/src/transport/HomaConfigDepot.cc
//configureation
configurations all from ownerTransport 
cComponent* ownerTransport
Thoughts: 1) Find the cComponent class constructor and see if changes can be made
          2) Directly adding a new parameter in the ownerTransport 
