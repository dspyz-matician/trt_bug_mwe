import sys
from matplotlib import pyplot as plt
import torch
import torch.nn as nn
import torch.onnx


MAX_TRAV = 21


class Traversability(nn.Module):
    def forward(self, untraversable: torch.Tensor) -> torch.Tensor:
        device = untraversable.device
        max_trav_sq = torch.tensor(MAX_TRAV**2, device=device, dtype=torch.int32)
        sq_distances = torch.where(untraversable, 0, max_trav_sq)
        extra_col = torch.full((sq_distances.shape[0], sq_distances.shape[1], 1), max_trav_sq, device=device)
        for d in range(1, MAX_TRAV * 2 + 1, 2):
            sq_distances = torch.minimum(
                sq_distances,
                torch.minimum(
                    torch.cat([sq_distances[:, :, 1:] + d, extra_col], 2),
                    torch.cat([extra_col, sq_distances[:, :, :-1] + d], 2),
                ),
            )
        extra_row = torch.full((sq_distances.shape[0], 1, sq_distances.shape[2]), max_trav_sq, device=device)
        for d in range(1, MAX_TRAV * 2 + 1, 2):
            sq_distances = torch.minimum(
                sq_distances,
                torch.minimum(
                    torch.cat([sq_distances[:, 1:, :] + d, extra_row], 1),
                    torch.cat([extra_row, sq_distances[:, :-1, :] + d], 1),
                ),
            )
        return sq_distances.sqrt()


# Create an instance of the model
model = Traversability()


def save_onnx():
    # Set the model to evaluation mode
    model.eval()

    # Define the input shape
    dummy_input = torch.randint(0, 2, (3, 224, 224), dtype=torch.bool)

    # Specify the output file path
    onnx_file_path = "traversability.onnx"

    # Convert the model to ONNX format
    torch.onnx.export(
        model,
        dummy_input,
        onnx_file_path,
        input_names=["input"],
        output_names=["output"],
    )

    print("Model converted to ONNX format. Saved as:", onnx_file_path)


def plot_test_input():
    untrav = torch.zeros((3, 224, 224), dtype=torch.bool, device=torch.device("cuda"))
    untrav[0, 4:40, 70:75] = True
    untrav[1, 60:80, 90:95] = True
    untrav[2, 20:30, 120:130] = True

    trav = model(untrav)

    plt.figure()
    plt.subplot(3, 2, 1)
    plt.imshow(untrav[0].to(torch.device("cpu")), cmap="gray")
    plt.subplot(3, 2, 2)
    plt.imshow(trav[0].to(torch.device("cpu")), cmap="viridis")
    plt.subplot(3, 2, 3)
    plt.imshow(untrav[1].to(torch.device("cpu")), cmap="gray")
    plt.subplot(3, 2, 4)
    plt.imshow(trav[1].to(torch.device("cpu")), cmap="viridis")
    plt.subplot(3, 2, 5)
    plt.imshow(untrav[2].to(torch.device("cpu")), cmap="gray")
    plt.subplot(3, 2, 6)
    plt.imshow(trav[2].to(torch.device("cpu")), cmap="viridis")
    plt.show()


if __name__ == "__main__":
    args = sys.argv[1:]
    if "save" in args:
        save_onnx()
    if "plot" in args:
        plot_test_input()
