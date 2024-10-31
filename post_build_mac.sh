#!/bin/bash

# Extract library names
ICU_UC_LIB_NAME=$(otool -L "${EXTERNAL_INSTALL_LOCATION}/lib/libOpenNMTTokenizer.dylib" | grep 'libicuuc' | sed -E 's|.*(libicuuc[^ ]*).*|\1|')
ICU_DATA_LIB_NAME=$(otool -L "${EXTERNAL_INSTALL_LOCATION}/lib/libOpenNMTTokenizer.dylib" | grep 'libicudata' | sed -E 's|.*(libicudata[^ ]*).*|\1|')
DNNL_LIB_NAME=$(otool -L "${EXTERNAL_INSTALL_LOCATION}/lib/libctranslate2.4.3.1.dylib" | grep 'libdnnl' | sed -E 's|.*(libdnnl[^ ]*).*|\1|')

# Echo extracted library names for logging
echo "Extracted ICU UC library name: ${ICU_UC_LIB_NAME}"
echo "Extracted ICU DATA library name: ${ICU_DATA_LIB_NAME}"
echo "Extracted DNNL library name: ${DNNL_LIB_NAME}"

# Modify install paths using install_name_tool
install_name_tool -change "${ONEDNN_ROOT}/lib/${DNNL_LIB_NAME}" @rpath/libdnnl.3.dylib "${EXTERNAL_INSTALL_LOCATION}/lib/libctranslate2.4.3.1.dylib"
install_name_tool -change "${ICU_LIBRARY_DIR}/${ICU_UC_LIB_NAME}" @rpath/libicuuc.dylib "${EXTERNAL_INSTALL_LOCATION}/lib/libctranslate2.4.3.1.dylib"
install_name_tool -change "${ICU_LIBRARY_DIR}/${ICU_DATA_LIB_NAME}" @rpath/libicudata.dylib "${EXTERNAL_INSTALL_LOCATION}/lib/libOpenNMTTokenizer.dylib"
install_name_tool -change "${ICU_LIBRARY_DIR}/${ICU_UC_LIB_NAME}" @rpath/libicuuc.dylib "${EXTERNAL_INSTALL_LOCATION}/lib/libOpenNMTTokenizer.dylib"

# Copy necessary files to build directory
cp "${ONEDNN_ROOT}/lib/libdnnl.3.dylib" "$1"
cp "${ICU_LIBRARY_DIR}/libicuuc.dylib" "$1"
cp "${ICU_LIBRARY_DIR}/libicudata.dylib" "$1"

install_name_tool -change "@loader_path/${ICU_DATA_LIB_NAME}" @loader_path/libicudata.dylib "$1/libicuuc.dylib"