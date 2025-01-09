#ifndef __LEOSATELLITEENV_INITIALISATIONMODULE_H_
#define __LEOSATELLITEENV_INITIALISATIONMODULE_H_

#include <omnetpp.h>

namespace leosatelliteenv{
    class InitialisationModule : public cSimpleModule
    {
      protected:
        virtual void initialize() override; // Initialisation logic
    };

    #endif // __LEOSATELLITEENV_INITIALIZATIONMODULE_H_

}

