import tensorrt as trt

# Create a TensorRT logger
logger = trt.Logger(trt.Logger.WARNING)

# Create a TensorRT builder
builder = trt.Builder(logger)

# Create a network
network = builder.create_network(
    1 << int(trt.NetworkDefinitionCreationFlag.EXPLICIT_BATCH)
)

# Parse the ONNX model
parser = trt.OnnxParser(network, logger)
parsed = parser.parse_from_file("traversability.onnx")
assert parsed
print("Parsed the ONNX model successfully.")

# Configure the builder
config = builder.create_builder_config()
config.max_workspace_size = 1 << 30  # Adjust the workspace size as needed
disabled_tactics = (
    (1 << int(trt.TacticSource.CUBLAS))
    | (1 << int(trt.TacticSource.CUBLAS_LT))
    | (1 << int(trt.TacticSource.CUDNN))
)
config.set_tactic_sources(config.get_tactic_sources() & ~disabled_tactics)
config.set_flag(trt.BuilderFlag.FP16)  # Enable FP16 precision if desired
print("Configured the builder successfully.")

# Create an engine
engine = builder.build_serialized_network(network, config)
assert engine is not None
print("Built the engine successfully.")

# Save the serialized engine to a file
with open("traversability.engine", "wb") as f:
    f.write(engine)
