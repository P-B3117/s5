import matplotlib.image as mpimg
import matplotlib.pyplot as plt
import numpy as np


def load_image(name: str) -> np.ndarray:
    plt.gray()
    img = mpimg.imread("assets/" + name)
    return img


def save_image(new_img: np.ndarray, name: str):
    mpimg.imsave(name, new_img, cmap="gray")


def load_array(name: str) -> np.ndarray:
    return np.load("assets/" + name)
