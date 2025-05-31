# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appteslaDashboard_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appteslaDashboard_autogen.dir\\ParseCache.txt"
  "appteslaDashboard_autogen"
  )
endif()
