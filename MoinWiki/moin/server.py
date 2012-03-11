#!/usr/bin/env python
"""
    Start script for the standalone Wiki server.

    @copyright: 2007 MoinMoin:ForrestVoight
    @license: GNU GPL, see COPYING for details.
"""

import sys, os, threading, signal, errno

# a) Configuration of Python's code search path
#    If you already have set up the PYTHONPATH environment variable for the
#    stuff you see below, you don't need to do a1) and a2).

# a1) Path of the directory where the MoinMoin code package is located.
#     Needed if you installed with --prefix=PREFIX or you didn't use setup.py.
#sys.path.insert(0, 'PREFIX/lib/python2.4/site-packages')
#lib_dir = os.path.join(os.path.abspath(os.path.dirname(__name__)),'lib/python2.7/site-packages')
#sys.path.insert(0, lib_dir)
# a2) Path of the directory where wikiconfig.py / farmconfig.py is located.
moinpath = os.path.abspath(os.path.normpath(os.path.dirname(sys.argv[0])))
sys.path.insert(0, moinpath)
os.chdir(moinpath)

# b) Configuration of moin's logging
#    If you have set up MOINLOGGINGCONF environment variable, you don't need this!
#    You also don't need this if you are happy with the builtin defaults.
#    See wiki/config/logging/... for some sample config files.

class MoinXParentMonitor(threading.Thread):
        """Monitor thread to exit the process if the parent dies.
           Author: Marcus Geiger.
        """
        SLEEP_TIMEOUT = 5 # in seconds

        def __init__(self):
                threading.Thread.__init__(self)
                self.__parentPid = os.getppid()
                if self.__parentPid == 1:
                        # Our parent already died, so init is our parent, stop here
                        raise StandardError, "Our parent died; Can't continue"
                #print 'Checking if parent %u is alive' % self.__parentPid
                # if no error, then our parent is alive
                os.kill(self.__parentPid, 0)
                print 'Monitoring parent process id: %u' % self.__parentPid
                self.__event = threading.Event()

        def notifyParent(self):
                """Parent should catch SIGUSR1 to update the menu status."""
                #print 'notifing parent %u' % self.__parentPid
                os.kill(self.__parentPid, signal.SIGUSR1)

        def run(self):
                #print 'in thread.run'
                while True:
                        #print 'Timer exceed'
                        self.__event.wait(MoinXParentMonitor.SLEEP_TIMEOUT)
                        self.monitor()
                        self.__event.clear() # for safety
                print 'exiting thread.run'

        def monitor(self):
                import os, signal
                ppid = os.getppid()
                if ppid != self.__parentPid:
                        print 'ppid changed to %u; killing myself' % ppid
                        pgrp = os.getpgrp()
                        print 'killing process group %u' % pgrp
                        os.kill(pgrp, signal.SIGTERM)

# Monitor parent process in a separate thread
def moinXStartParentMonitor():
        """Actually start a MoinXParentMonitor thread."""
        monitor = MoinXParentMonitor()
        monitor.setDaemon(True)
        monitor.start()
        monitor.notifyParent()

moinXStartParentMonitor()
#for log of server.
from MoinMoin import log
log.load_config('wikiserverlogging.conf')

from MoinMoin.script import MoinScript
#run the server
if __name__ == '__main__':
    sys.argv = ["moin.py", "server", "standalone"]
    MoinScript().run()
