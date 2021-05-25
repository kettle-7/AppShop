cmake_minimum_required(VERSION 3.14)

project(AppShop LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check http://doc.qt.io/qt-5/deployment-android.html for more information.
# They need to be set before the find_package(Qt5 ...) call.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick LinguistTools REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick LinguistTools REQUIRED)

# Recognise those people who don't know how to spell the word recognise
set(TS_FILES lang/en_US.ts)

if(ANDROID)
    add_library(AppShop SHARED
      main.cpp
      qml.qrc
      ${TS_FILES}
    )
else()
    add_executable(AppShop
      main.cpp
      qml.qrc
      ${TS_FILES}
    )
endif()

# Even though CLang++ throws -Wunused-flag, we need this for it to find libcurl.
INCLUDE_DIRECTORIES ( . )
set (CMAKE_CXX_FLAGS -L/usr/local/lib)

target_compile_definitions(AppShop
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
link_directories(/usr/local/lib)
target_link_libraries(AppShop
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick curl)

qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
