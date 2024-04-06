import numpy as np
import tensorrt as trt
import pycuda.driver as cuda
import pycuda.autoinit  # Add this line to initialize the CUDA context
from matplotlib import pyplot as plt

# Load the serialized engine
with open("traversability.engine", "rb") as f:
    serialized_engine = f.read()

# Create a TensorRT runtime
runtime = trt.Runtime(trt.Logger(trt.Logger.WARNING))

# Deserialize the engine
engine = runtime.deserialize_cuda_engine(serialized_engine)

# Execute inference
with engine.create_execution_context() as context:
    # Allocate memory for inputs and outputs
    input_shape = (3, 224, 224)
    input_dtype = np.bool_
    output_shape = (3, 224, 224)
    output_dtype = np.float32

    input_mem = cuda.mem_alloc(
        input_shape[0] * input_shape[1] * input_shape[2] * np.dtype(input_dtype).itemsize
    )
    output_mem = cuda.mem_alloc(
        output_shape[0] * output_shape[1] * input_shape[2] * np.dtype(output_dtype).itemsize
    )

    # Create a test input
    untrav = np.zeros(input_shape, dtype=input_dtype)
    untrav[0, 4:40, 70:75] = True
    untrav[1, 60:80, 90:95] = True
    untrav[2, 20:30, 120:130] = True

    # Copy input data to device
    cuda.memcpy_htod(input_mem, untrav)

    # Set input and output bindings
    bindings = [int(input_mem), int(output_mem)]

    # Execute inference
    context.execute_v2(bindings)

    # Copy output data from device to host
    output = np.empty(output_shape, dtype=output_dtype)
    cuda.memcpy_dtoh(output, output_mem)

# Plot the input and output
plt.figure()
plt.subplot(3, 2, 1)
plt.imshow(untrav[0], cmap="gray")
plt.subplot(3, 2, 2)
plt.imshow(output[0], cmap="viridis")
plt.subplot(3, 2, 3)
plt.imshow(untrav[1], cmap="gray")
plt.subplot(3, 2, 4)
plt.imshow(output[1], cmap="viridis")
plt.subplot(3, 2, 5)
plt.imshow(untrav[2], cmap="gray")
plt.subplot(3, 2, 6)
plt.imshow(output[2], cmap="viridis")
plt.show()
