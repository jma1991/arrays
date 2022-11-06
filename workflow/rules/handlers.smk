# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

# Print message when workflow starts
onstart:
    print(colors.BOLD + colors.OKBLUE + "Workflow started!" + colors.ENDC)

# Print message when workflow is successful
onsuccess:
    print(colors.BOLD + colors.OKGREEN + "Workflow finished!" + colors.ENDC)

# Print message when workflow throws an error
onerror:
    print(colors.BOLD + colors.FAIL + "Workflow errored!" + colors.ENDC)
