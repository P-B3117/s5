from pathlib import Path

import matplotlib.image as mpimg
import matplotlib.pyplot as plt
import numpy as np


def load_image(name: str) -> np.ndarray:
    plt.gray()
    assets_dir = Path(__file__).resolve().parent / "assets"
    img = mpimg.imread(str(assets_dir / name))
    return img


def save_image(new_img: np.ndarray, name: str):
    mpimg.imsave(name, new_img, cmap="gray")


def load_array(name: str) -> np.ndarray:
    assets_dir = Path(__file__).resolve().parent / "assets"
    return np.load(str(assets_dir / name))
