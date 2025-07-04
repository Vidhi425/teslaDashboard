cmake_minimum_required(VERSION 3.16)

project(teslaDashboard VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Location)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_resources(MyResources res.qrc)

qt_add_executable(appteslaDashboard
    main.cpp
    ${MyResources}
)

qt_add_qml_module(appteslaDashboard
    URI teslaDashboard
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
        res.qrc
        SOURCES
        SOURCES
        SOURCES
        SOURCES
        SOURCES Resources/system2.h Resources/system2.cpp
        SOURCES Resources/hvachandler.h Resources/hvachandler.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appteslaDashboard PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appteslaDashboard
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appteslaDashboard
    PRIVATE Qt6::Quick Qt6::Location
)

include(GNUInstallDirs)
install(TARGETS appteslaDashboard
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
