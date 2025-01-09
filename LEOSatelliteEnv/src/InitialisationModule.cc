#include <omnetpp.h>
#include "InitialisationModule.h"

namespace leosatelliteenv {

    void InitialisationModule::initialize()
    {
        int numPlanes = par("numPlanes");
        int clusterSize = par("clusterSize");
        int numSatellites = par("numSatellites");

        // Access satellites by name
        for (int plane = 0; plane < numPlanes; ++plane) {
            for (int i = 0; i < clusterSize; ++i) {
                int satIndex1 = plane * clusterSize + i;
                int satIndex2 = plane * clusterSize + (i + 1) % clusterSize;

                // Get satellite modules
                cModule *sat1 = getParentModule()->getSubmodule("satellite", satIndex1);
                cModule *sat2 = getParentModule()->getSubmodule("satellite", satIndex2);

                omnetpp::cGate *gate1 = sat1->gate("pppg$o");
                omnetpp::cGate *gate2 = sat2->gate("pppg$i");

                omnetpp::cChannel *channel = omnetpp::cChannelType::get("DatarateChannel")->create("intraPlaneChannel");
                gate1->connectTo(gate2, channel);
            }
        }
    }

    Define_Module(InitialisationModule);

}
