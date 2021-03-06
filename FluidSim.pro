# This specifies the exe name
TARGET=FluidSim
# where to put the .o files

QMAKE_CXXFLAGS += -fopenmp
QMAKE_LFLAGS += -fopenmp

OBJECTS_DIR=obj
# core Qt Libs to use add more here if needed.
QT+=gui opengl core

linux*:INCLUDEPATH+= /usr/local/alembic-1.5.8/include/
linux*:LIBS+=-L/usr/local/alembic-1.5.8/lib/static


linux*:LIBS+= -lAbcWFObjConvert         -lAlembicAbcCoreOgawa \
-lAlembicAbc              -lAlembicAbcGeom \
-lAlembicAbcCollection   -lAlembicAbcMaterial \
-lAlembicAbcCoreAbstract  -lAlembicAbcOpenGL \
-lAlembicAbcCoreFactory   -lAlembicOgawa \
-lAlembicAbcCoreHDF5      -lAlembicUtil

linux*:LIBS+=-L/usr/local/lib -lHalf

# as I want to support 4.8 and 5 this will set a flag for some of the mac stuff
# mainly in the types.h file for the setMacVisual which is native in Qt5
isEqual(QT_MAJOR_VERSION, 5) {
	cache()
	DEFINES +=QT5BUILD
}
# where to put moc auto generated files
MOC_DIR=moc
# on a mac we don't create a .app bundle file ( for ease of multiplatform use)
CONFIG-=app_bundle
# Auto include all .cpp files in the project src directory (can specifiy individually if required)
SOURCES+= $$PWD/src/main.cpp \
          $$PWD/src/NGLScene.cpp \
          src/Particle.cpp \
          src/Emitter.cpp \
          src/Cell.cpp \
          src/Grid.cpp \
    src/Fluid.cpp \
    src/SHash.cpp \
    src/Boundary.cpp \
    src/RBD.cpp
# same for the .h files
HEADERS+= $$PWD/include/NGLScene.h \
    include/Particle.h \
    include/Emitter.h \
    include/Cell.h \
    include/Grid.h \
    include/Fluid.h \
    include/SHash.h \
    include/Boundary.h \
    include/RBD.h
# and add the include dir into the search path for Qt and make
INCLUDEPATH +=./include
INCLUDEPATH+=/usr/local/include/OpenEXR
# where our exe is going to live (root of project)
DESTDIR=./
# add the glsl shader files
OTHER_FILES+= README.md\
              $$PWD/shaders/colour.fs \
              $$PWD/shaders/colour.vs
# were are going to default to a console app
CONFIG += console
# note each command you add needs a ; as it will be run as a single line
# first check if we are shadow building or not easiest way is to check out against current
!equals(PWD, $${OUT_PWD}){
	copydata.commands = echo "creating destination dirs" ;
	# now make a dir
	copydata.commands += mkdir -p $$OUT_PWD/shaders ;
	copydata.commands += echo "copying files" ;
	# then copy the files
	copydata.commands += $(COPY_DIR) $$PWD/shaders/* $$OUT_PWD/shaders/ ;
	# now make sure the first target is built before copy
	first.depends = $(first) copydata
	export(first.depends)
	export(copydata.commands)
	# now add it as an extra target
	QMAKE_EXTRA_TARGETS += first copydata
}
NGLPATH=$$(NGLDIR)
isEmpty(NGLPATH){ # note brace must be here
	message("including $HOME/NGL")
	include($(HOME)/NGL/UseNGL.pri)
}
else{ # note brace must be here
	message("Using custom NGL location")
	include($(NGLDIR)/UseNGL.pri)
}
