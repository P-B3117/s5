from typing import Callable

import numpy as np
from scipy.signal import bilinear, butter, buttord, lfilter

from assets import load_array, load_image, save_image


def compressImage(image: np.ndarray, keep_ratio: float) -> np.ndarray:
    k = int(image.shape[1] * keep_ratio)

    compressed_transformed = np.zeros_like(image)
    compressed_transformed[:, :k] = image[:, :k]

    return compressed_transformed


def decompress_image(compressed_image: np.ndarray, P) -> np.ndarray:
    restored_img = np.dot(compressed_image, P)
    # restored_img += np.mean(image, axis=0)  # On rajoute la moyenne soustraite au début
    return restored_img


def process_image(image: np.ndarray, keep_ratio: float) -> np.ndarray:
    covariant_img = np.cov(image, rowvar=False)
    eigenvalues_img, eigenvectors_img = np.linalg.eigh(covariant_img)

    sorted_idx = np.argsort(eigenvalues_img)[::-1]
    eigenvalues_img = eigenvalues_img[sorted_idx]
    eigenvectors_img = eigenvectors_img[:, sorted_idx]

    P = eigenvectors_img.T

    transformed_img = np.dot(image, P.T)

    compressed_img = compressImage(transformed_img.copy(), keep_ratio)

    decompressed_img = decompress_image(compressed_img, P)

    return decompressed_img


if __name__ == "__main__":
    img = load_image("goldhill.png")

    covariant_img = np.cov(img, rowvar=False)
    eigenvalues_img, eigenvectors_img = np.linalg.eigh(covariant_img)

    sorted_idx = np.argsort(eigenvalues_img)[::-1]
    eigenvalues_img = eigenvalues_img[sorted_idx]
    eigenvectors_img = eigenvectors_img[:, sorted_idx]

    P = eigenvectors_img.T

    transformed_img = np.dot(img, P.T)

    compressed_img = compressImage(transformed_img.copy(), 0.5)

    decompressed_img = decompress_image(compressed_img, P)

    save_image(decompressed_img, "compressed_goldhill.png")

    compressed_img = compressImage(transformed_img.copy(), 0.7)

    decompressed_img = decompress_image(compressed_img, P)

    save_image(decompressed_img, "compressed_goldhill70.png")
