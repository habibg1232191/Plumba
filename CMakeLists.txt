cmake_minimum_required(VERSION 3.16)

project(plumba VERSION 0.1 LANGUAGES CXX)

set(APP_NAME ${PROJECT_NAME})

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

find_package(Corrosion QUIET)
if(NOT Corrosion_FOUND)
    include(FetchContent)
    FetchContent_Declare(
        Corrosion
        GIT_REPOSITORY https://github.com/corrosion-rs/corrosion.git
        GIT_TAG v0.4.2
    )

    FetchContent_MakeAvailable(Corrosion)
endif()

get_target_property(QMAKE Qt::qmake IMPORTED_LOCATION)
message("CMAKE CURRENT BINARY DIR")
message(${CMAKE_CURRENT_BINARY_DIR}/cxxqt)
message(${QMAKE})
set(CRATE plugin-system)
corrosion_import_crate(MANIFEST_PATH rust/Cargo.toml CRATES ${CRATE})

set(CXXQT_EXPORT_DIR "${CMAKE_CURRENT_BINARY_DIR}/cxxqt")
corrosion_set_env_vars(${CRATE}
    "CXXQT_EXPORT_DIR=${CXXQT_EXPORT_DIR}"
    "QMAKE=${QMAKE}"
)

add_library(${APP_NAME}_lib INTERFACE)

qt_standard_project_setup()

qt_add_executable(appplumba
    cpp/main.cpp
    resource.qrc
)

#qt_import_qml_plugins(${APP_NAME})

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appplumba PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appplumba
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_include_directories(${APP_NAME}_lib INTERFACE "${CXXQT_EXPORT_DIR}/${CRATE}")

target_link_libraries(${APP_NAME}_lib INTERFACE
    # WHOLE_ARCHIVE is needed for the generated QML plugin to register on startup,
    # otherwise the linker will discard the static variables that initialize it.
    "$<LINK_LIBRARY:WHOLE_ARCHIVE,${CRATE}-static>"
    Qt::Core
    Qt::Gui
    Qt::Qml
)

#target_link_libraries(${APP_NAME} PRIVATE)

target_link_libraries(appplumba
    PRIVATE Qt6::Quick ${APP_NAME}_lib
)

include(GNUInstallDirs)
install(TARGETS appplumba
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
