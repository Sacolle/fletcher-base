
                
DRIVER_DIR="${DRIVER_DIR:-$PWD}/.cuda-drivers"
mkdir -p "$DRIVER_DIR"

LIBCUDA_PATH=$(find /usr -name "libcuda.so.1" 2>/dev/null | head -n 1)

if [ -z "$LIBCUDA_PATH" ]; then
    echo "Warning: Could not find libcuda.so.1 on host. GPU might not work."
else
    LIB_PATH=$(dirname $LIBCUDA_PATH)
    echo "Found host driver at: $LIB_PATH"

    ln -sf "$LIB_PATH"/libcuda.so* "$DRIVER_DIR/"
    # ln -sf "$HOST_DIR"/libnvidia-fatbinaryloader.so* "$DRIVER_DIR/" 2>/dev/null || true
    
    # 3. Inject only our "clean" driver folder into the path
    export LD_LIBRARY_PATH="$DRIVER_DIR:$LD_LIBRARY_PATH"
    echo "Added the newly made $DRIVER_DIR to LD_LIBRARY_PATH"
fi

